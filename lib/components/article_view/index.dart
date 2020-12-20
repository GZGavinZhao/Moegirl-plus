
import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_viewer/api/article.dart';
import 'package:moegirl_viewer/components/article_view/utils/create_moegirl_renderer_config.dart';
import 'package:moegirl_viewer/components/html_web_view/index.dart';
import 'package:moegirl_viewer/components/indexed_view.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/settings.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/request/plain_request.dart';
import 'package:moegirl_viewer/themes.dart';
import 'package:moegirl_viewer/utils/article_cache_manager.dart';
import 'package:moegirl_viewer/utils/color2rgb_css.dart';
import 'package:moegirl_viewer/utils/media_wiki_namespace.dart';
import 'package:moegirl_viewer/utils/provider_change_checker.dart';
import 'package:moegirl_viewer/utils/check_if_nonauto_confirmed_to_show_edit_alert.dart';
import 'package:moegirl_viewer/utils/ui/dialog/alert.dart';
import 'package:moegirl_viewer/utils/ui/dialog/loading.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/category/index.dart';
import 'package:moegirl_viewer/views/edit/index.dart';
import 'package:moegirl_viewer/views/image_previewer/index.dart';
import 'package:one_context/one_context.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../styled_widgets/circular_progress_indicator.dart';
import 'utils/collect_data_from_html.dart';
import 'utils/show_note_dialog.dart';

final moegirlRendererJsFuture = rootBundle.loadString('assets/main.js');
final moegirlRendererCssFuture = rootBundle.loadString('assets/main.css');

class ArticleView extends StatefulWidget {
  final String pageName;
  final String html;
  final int revId;  // pageName和revId只能传一个
  final List<String> injectedStyles;
  final List<String> injectedScripts;
  final bool disabledLink;
  final bool fullHeight;
  final bool inDialogMode;
  final bool editAllowed;
  final double contentTopPadding;
  final Map<String, void Function(dynamic data)> messageHandlers;
  final void Function(ArticleViewController) emitArticleController;
  final void Function(dynamic contentsData) emitContentData;
  final void Function(dynamic articleData, dynamic pageInfo) onArticleLoaded;
  final void Function(String pageName) onArticleMissed;
  final void Function(String pageName) onArticleError;

  ArticleView({
    Key key,
    this.pageName,
    this.html,
    this.revId,
    this.injectedStyles = const [],
    this.injectedScripts = const [],
    this.disabledLink = false,
    this.fullHeight = false,
    this.inDialogMode = false,
    this.editAllowed = true,
    this.contentTopPadding = 0,
    this.messageHandlers = const {},
    this.emitArticleController,
    this.emitContentData,
    this.onArticleLoaded,
    this.onArticleMissed,
    this.onArticleError
  }) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> with ProviderChangeChecker {  
  dynamic articleData;
  List<String> injectedStyles;
  List<String> injectedScripts;
  int status = 1;
  Map<String, String> imgOriginalUrls; 
  HtmlWebViewController htmlWebViewController;
  static double maxContainerHeight = 
    MediaQueryData.fromWindow(window).size.height - 
    MediaQueryData.fromWindow(window).padding.top -
    kToolbarHeight
  ;
  double contentHeight = maxContainerHeight;

  @override
  void initState() {
    super.initState();
    if (widget.pageName != null) {
      loadArticleContent(widget.pageName);
    } else {
      updateWebHtmlView();
    }

    if (widget.emitArticleController != null) {
      widget.emitArticleController(ArticleViewController(reload, injectScript));
    }

    // 监听设置项heimu的变化
    addChangeChecker<SettingsProviderModel, bool>(
      provider: settingsProvider,
      selector: (provider) => provider.heimu,
      handler: (value) {
        injectScript('moegirl.config.heimu.\$enabled = ${value.toString()}');
      }
    );

    // 监听设置项theme的变化
    addChangeChecker<SettingsProviderModel, String>(
      provider: settingsProvider,
      selector: (provider) => provider.theme,
      handler: (value) {
        final theme = themes[value];
        final isNightTheme = value == 'night';
        injectScript('''
          moegirl.config.nightTheme.\$enabled = ${isNightTheme.toString()}
          \$('body').css('background-color', '${color2rgbCss(theme.backgroundColor)}')
        ''');
        if (!isNightTheme) {
          injectScript('''
            \$(':root').css({
              '--color-primary': '${color2rgbCss(theme.primaryColor)}',
              '--color-dark': '${color2rgbCss(theme.primaryColorDark)}',
              '--color-light': '${color2rgbCss(theme.primaryColorLight)}'
            })
          ''');
        }
      }
    );
  }
  
  Future loadArticleContent(String pageName, [bool forceLoad = false]) async {
    if (status == 2) return;    
    setState(() => status = 2);

    try {
      final truePageName = await ArticleApi.getTruePageName(pageName);
      final pageInfo = await ArticleApi.getPageInfo(truePageName);

      final isCategoryPage = getPageNamespace(pageInfo['ns']) == MediaWikiNamespace.category;

      if (isCategoryPage) {
        // 如果是分类页则收集页面数据后跳转
        // 如果加载失败了一定会显示重新加载按钮，因为category不会存缓存
        final articleData = await ArticleApi.articleDetail(pageName: truePageName);
        final collectedCategoryData = collectCategoryDataFromHtml(articleData['parse']['text']['*']);

        OneContext().pushReplacementNamed('/category', arguments: CategoryPageRouteArgs(
          categoryName: truePageName.replaceAll('Category:', ''),
          parentCategories: collectedCategoryData.parentCategories,
          categoryExplainPageName: collectedCategoryData.categoryExplainPageName
        ));

        return;
      }

      // 在非强制加载、非讨论页、非加载历史页面、有缓存的情况下，使用缓存
      if (!forceLoad && !isTalkPage(pageInfo['ns']) && widget.revId == null && settingsProvider.cachePriority) {
        // 使用缓存
        final articleCache = await ArticleCacheManager.getCache(pageName);
        if (articleCache != null) {
          updateWebHtmlView(articleCache.articleData);

          // 后台请求一次文章数据，更新缓存
          final articleData = await ArticleApi.articleDetail(pageName: truePageName);
          ArticleCacheManager.addCache(pageName, ArticleCache(
            articleData: articleData,
            pageInfo: pageInfo
          ));

          return;
        }
      }

      // 请求接口数据
      final articleData = await ArticleApi.articleDetail(
        pageName: widget.revId != null ? null : truePageName,
        revId: widget.revId
      );

      if (widget.onArticleLoaded != null) widget.onArticleLoaded(articleData, pageInfo);

      // 建立缓存
      if (widget.pageName != truePageName && widget.revId == null) {
        ArticleCacheManager.addRedirect(widget.pageName, truePageName);
      }
      ArticleCacheManager.addCache(truePageName, ArticleCache(
        articleData: articleData,
        pageInfo: pageInfo
      ))
        .catchError((e) {
          print('文章图片原始链接获取失败');
          print(e);
        });

      // 加载条目内图片原始地址，用于大图预览
      loadImgOriginalUrls(
        articleData['parse']['images'].cast<String>()
          .where((String e) => e.contains(RegExp(r'/\.svg$/')) == false)
          .toList()
      )
        .catchError((e) {
          print('文章图片原始链接获取失败');
          print(e);
        });

      updateWebHtmlView(articleData);
    } catch(e) {
      print(e);
      print('加载文章数据失败');
      if (!(e is DioError) && !(e is MoeRequestError)) rethrow;
      if (e is MoeRequestError && widget.onArticleMissed != null) widget.onArticleMissed(pageName);
      if (e is DioError) {
        final articleCache = await ArticleCacheManager.getCache(pageName);
        if (articleCache != null) {
          toast('加载文章失败，载入缓存');
          if (widget.onArticleLoaded != null) widget.onArticleLoaded(articleCache.articleData, articleCache.pageInfo);
          updateWebHtmlView(articleCache.articleData);
        } else {
          setState(() => status = 0);
          toast('加载文章失败');
          if (widget.onArticleError != null) widget.onArticleError(pageName);
        }
      }
    }
  }

  Future<void> loadImgOriginalUrls(List<String> imgNames) {
    return ArticleApi.getImagesUrl(imgNames)
      .then((value) => setState(() => imgOriginalUrls = value));
  }

  void reload([bool forceLoad = false]) async {
    await loadArticleContent(widget.pageName, forceLoad);
    htmlWebViewController.reload();
  }

  Future<String> injectScript(String script) {
    return htmlWebViewController.webViewController.evaluateJavascript(script);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  void updateWebHtmlView([dynamic articleData]) async {
    final moegirlRendererJs = await moegirlRendererJsFuture;
    final moegirlRendererCss = await moegirlRendererCssFuture;

    final categories = articleData != null ? articleData['parse']['categories'].map((e) => e['*']).toList().cast<String>() : <String>[];
    final moegirlRendererConfig = createMoegirlRendererConfig(
      pageName: widget.pageName,
      categories: categories,
      enbaledHeightObserver: widget.fullHeight,
      heimu: settingsProvider.heimu,
      addCopyright: !widget.inDialogMode,
      nightMode: settingsProvider.theme == 'night'
    );

    final theme = Theme.of(OneContext().context);
    final styles = '''
      body {
        padding-top: ${widget.contentTopPadding}px;
        word-break: ${widget.inDialogMode ? 'break-all' : 'initial'};
        background-color: ${color2rgbCss(theme.backgroundColor)};
      }

      :root {
        --color-primary: ${color2rgbCss(theme.primaryColor)};
        --color-dark: ${color2rgbCss(theme.primaryColorDark)};
        --color-light: ${color2rgbCss(theme.primaryColorLight)};
      }
    ''';

    final js = '''

    ''';

    setState(() {
      injectedStyles = [moegirlRendererCss, styles, ...widget.injectedStyles];
      injectedScripts = [moegirlRendererJs, moegirlRendererConfig, js, ...widget.injectedScripts];
      this.articleData = articleData;
    });
  }

  Map<String, void Function(dynamic data)> get messageHandlers {
    return {
      'link': (dynamic _data) async {
        final type = _data['type'];
        final data = _data['data'];

        if (type == 'article') {
          if (widget.disabledLink) return;
          OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
            pageName: data['pageName'],
            anchor: data['anchor'],
            displayPageName: data['displayName']
          ));
        }

        if (type == 'img') {
          final String imgName = data['name'].replaceAll('_', ' ');
          if (imgName.contains(RegExp(r'\.svg$'))) {
            toast('无法预览svg图片');
            return;
          }

          String imageUrl;
          if (imgOriginalUrls != null) {
            imageUrl = imgOriginalUrls[imgName];
          } else {
            showLoading(
              text: '获取图片链接中...', 
              barrierDismissible: true
            );
            try {
              imageUrl = (await ArticleApi.getImagesUrl([imgName]))[imgName];
            } catch (e) {
              print('获取单个图片原始链接失败');
              toast('获取图片链接失败');
              print(e);
            } finally {
              OneContext().pop();
            }
          }

          OneContext().pushNamed('imagePreviewer', arguments: ImagePreviewerPageRouteArgs(
            imageUrl: imageUrl
          ));
        }

        if (type == 'note') {
          showNoteDialog(context, data['html']);
        }

        if (type == 'anchor') {
          injectScript('moegirl.method.link.gotoAnchor(\'${data['id']}\', -${widget.contentTopPadding})');
        }

        if (type == 'notExist') {
          showAlert(content: '该条目还未创建');
        }

        if (type == 'edit') {
          if (widget.disabledLink) return;
          if (!widget.editAllowed) {
            showAlert(content: '没有权限编辑该页面');
            return;
          }

          if (!accountProvider.isLoggedIn) {
            final result = await showAlert(
              content: '未登录无法进行编辑，要前往登录界面吗？'
            );
            if (result) OneContext().pushNamed('/login');
            return;
          }

          final sectionStr = data['section'] is int ? data['section'].toString() : null;
          final isNonautoConfirmed = await checkIfNonautoConfirmedToShowEditAlert(data['pageName'], sectionStr);
          if (isNonautoConfirmed) return;

          OneContext().pushNamed('/edit', arguments: EditPageRouteArgs(
            pageName: data['pageName'], 
            editRange: EditPageEditRange.section,
            section: sectionStr
          ));
        }

        if (type == 'watch') {

        }

        if (type == 'external') {
          launch(data['url']);
        }

        if (type == 'externalImg') {
          OneContext().pushNamed('/imagePreviewer', arguments: ImagePreviewerPageRouteArgs(
            imageUrl: data['url']
          ));
        }

        if (type == 'unparsed') {}
      },

      'contentsData': (data) {
        if (widget.emitContentData != null) widget.emitContentData(data);
      },

      'loaded': (_) {
        if (articleHtml != '') setState(() => status = 3);
      },

      'pageHeightChange': (height) {
        setState(() => contentHeight = height);
      },

      'biliPlayer': (data) {
        launch('https://www.bilibili.com/video/${data['type']}${data['videoId']}?p=${data['page']}');
      },

      'biliPlayerLongPress': (data) {

      },

      'request': (data) async {
        try {
          final res = await baseRequest.request(data['url'],
            queryParameters: data['method'] != 'post' ? data['data'] : null,
            data: data['method'] == 'post' ? data['data'] : null,
            options: RequestOptions(
              method: data['method']
            )
          );

          injectScript('moegirl.config.request.callbacks[\'${data['callbackId']}\'].resolve(${jsonEncode(res.data)})');
        } catch(e) {
          print(e);
          injectScript('moegirl.config.request.callbacks[\'${data['callbackId']}\'].reject(${jsonEncode(e)})');
        }
      },

      'vibrate': (data) {
        // Vibration.vibrate();
      }
    };
  }

  String get articleHtml {
    if (widget.html != null) return widget.html;
    if (articleData == null) return '';
    return articleData['parse']['text']['*'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);    
    double finalContainerHeight;
    if (widget.fullHeight) finalContainerHeight = status == 3 ? contentHeight : maxContainerHeight;

    return Container(
      alignment: Alignment.center,
      height: finalContainerHeight,
      child: IndexedStack(
        index: status == 3 ? 0 : 1,
        children: [
          HtmlWebView(
            body: articleHtml, 
            title: widget.pageName,
            injectedStyles: injectedStyles,
            injectedScripts: injectedScripts,
            messageHandlers: {
              ...messageHandlers,
              ...widget.messageHandlers
            },
            onWebViewCreated: (controller) => htmlWebViewController = controller,
          ),

          Container(
            margin: EdgeInsets.only(top: widget.contentTopPadding),
            alignment: Alignment.center,
            child: IndexedView(
              index: status,
              builders: {
                0: () => TextButton(
                  onPressed: () => reload(true),
                  child: Text('重新加载',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
                2: () => StyledCircularProgressIndicator(),
              }
            ),
          )
        ],
      ),
    );
  }
}

class ArticleViewController {
  final void Function([bool force]) reload;
  final Future<String> Function(String script) injectScript;
  
  ArticleViewController(this.reload, this.injectScript);
}