// @dart=2.9

import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:moegirl_plus/api/account.dart';
import 'package:moegirl_plus/api/article.dart';
import 'package:moegirl_plus/components/article_view/utils/create_moegirl_renderer_config.dart';
import 'package:moegirl_plus/components/html_web_view/index.dart';
import 'package:moegirl_plus/components/indexed_view.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/request/plain_request.dart';
import 'package:moegirl_plus/themes.dart';
import 'package:moegirl_plus/utils/article_cache_manager.dart';
import 'package:moegirl_plus/utils/check_if_nonauto_confirmed_to_show_edit_alert.dart';
import 'package:moegirl_plus/utils/color2rgb_css.dart';
import 'package:moegirl_plus/utils/encode_js_eval_codes.dart';
import 'package:moegirl_plus/utils/media_wiki_namespace.dart';
import 'package:moegirl_plus/utils/provider_change_checker.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/category/index.dart';
import 'package:moegirl_plus/views/edit/index.dart';
import 'package:moegirl_plus/views/image_previewer/index.dart';
import 'package:one_context/one_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styled_widgets/circular_progress_indicator.dart';
import 'utils/collect_data_from_html.dart';
import 'utils/show_note_dialog.dart';

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
  final bool addCopyright;
  final double contentTopPadding;
  final Map<String, void Function(dynamic data)> messageHandlers;
  final void Function(ArticleViewController) emitArticleController;
  final void Function(dynamic contentsData) emitContentData;  // 目录数据
  final void Function(dynamic articleData, dynamic pageInfo) onArticleLoaded;
  final void Function() onArticleRendered; 
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
    this.addCopyright = true,
    this.contentTopPadding = 0,
    this.messageHandlers = const {},
    this.emitArticleController,
    this.emitContentData,
    this.onArticleRendered,
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
      widget.emitArticleController(ArticleViewController(
        reload, 
        injectScript,
        () => htmlWebViewController.webViewController
      ));
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
          document.body.style.backgroundColor = '${isNightTheme ? '#252526' : 'white'}'
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
          categoryName: truePageName.replaceFirst('Category:', '').replaceFirst('分类:', ''),
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
          if (widget.onArticleLoaded != null) widget.onArticleLoaded(articleCache.articleData, pageInfo);

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
      loadImgOriginalUrls(articleData['parse']['images'].cast<String>())
        .catchError((e) {
          print('文章图片原始链接获取失败');
          print(e);
        });

      updateWebHtmlView(articleData);
    } catch(e) {
      print(e);
      print('加载文章数据失败');
      if (!(e is DioError) && !(e is MoeRequestError)) rethrow;
      if (e is MoeRequestError && widget.onArticleMissed != null) return widget.onArticleMissed(pageName);

      final articleCache = await ArticleCacheManager.getCache(pageName);
      if (articleCache != null) {
        toast(Lang.loadArticleErrToUseCache);
        if (widget.onArticleLoaded != null) widget.onArticleLoaded(articleCache.articleData, articleCache.pageInfo);
        updateWebHtmlView(articleCache.articleData);
      } else {
        setState(() => status = 0);
        toast(Lang.loadArticleErr);
        if (widget.onArticleError != null) widget.onArticleError(pageName);
      }
    }
  }

  Future<void> loadImgOriginalUrls(List<String> imgNames) {
    return ArticleApi.getImagesUrl(imgNames)
      .then((value) => setState(() => imgOriginalUrls = value));
  }

  void reload([bool forceLoad = false]) async {
    await loadArticleContent(widget.pageName, forceLoad);
  }

  Future<dynamic> injectScript(String script) {
    return htmlWebViewController?.webViewController?.evaluateJavascript(source: script);
  }

  void updateWebHtmlView([dynamic articleData]) async {
    final categories = articleData != null ? articleData['parse']['categories']
      .where((item) => !item.containsKey('hidden'))
      .map((e) => e['*'])
      .toList()
      .cast<String>()
    : <String>[];
    final moegirlRendererConfig = createMoegirlRendererConfig(
      pageName: widget.pageName,
      language: settingsProvider.lang,
      site: RuntimeConstants.source,
      enabledCategories: true,
      categories: categories,
      enbaledHeightObserver: widget.fullHeight,
      heimu: settingsProvider.heimu,
      addCopyright: !widget.inDialogMode && widget.addCopyright,
      nightMode: settingsProvider.theme == 'night'
    );

    final theme = Theme.of(OneContext().context);
    final styles = '''
      body {
        padding-top: ${widget.contentTopPadding}px;
        word-break: ${widget.inDialogMode ? 'break-all' : 'initial'};
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
      injectedStyles = [styles, ...widget.injectedStyles];
      injectedScripts = [moegirlRendererConfig, js, ...widget.injectedScripts];

      final oldArticleHthml = articleHtml;
      this.articleData = articleData;
      if (oldArticleHthml == articleHtml) htmlWebViewController.reload();
    });
  }

  Map<String, void Function(dynamic data)> get messageHandlers {
    return {
      'link': (dynamic _data) async {
        final type = _data['type'];
        final data = _data['data'];

        if (type == 'article') {          
          final String pageName = data['pageName'];
          final String anchor = data['anchor'];   // number | 'new'
          final String displayName = data['displayName'];
          
          if (pageName.contains(RegExp(r'^Special:'))) {
            showAlert<bool>(content: Lang.specialLinkUnsupported);
            return;
          }
          
          if (widget.disabledLink) return;
          OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
            pageName: pageName,
            anchor: anchor,
            displayPageName: displayName
          ));
        }

        if (type == 'img') {
          final List<MoegirlImage> images = data['images'].map((item) => MoegirlImage.fromMap(item)).cast<MoegirlImage>().toList();
          final int clickedIndex = images.length == 1 ? 0 : data['clickedIndex'];

          var imgOriginalUrls = this.imgOriginalUrls;

          if (imgOriginalUrls == null) {
            showLoading(
              text: Lang.gettingImageUrl, 
              barrierDismissible: true
            );

            try {
              final imageFileNames = images.map((item) => item.fileName).cast<String>().toList();
              imgOriginalUrls = await ArticleApi.getImagesUrl(imageFileNames);
            } catch (e) {
              print('用户触发获取图片原始链接失败');
              toast(Lang.getImageUrlFail);
              print(e);
              return;
            } finally {
              OneContext().pop();
            }
          }

          images.forEach((item) {
            item.fileUrl = imgOriginalUrls[item.fileName];
          });

          OneContext().pushNamed('/imagePreviewer', arguments: ImagePreviewerPageRouteArgs(
            images: images,
            initialIndex: clickedIndex
          ));
        }

        if (type == 'note') {
          final String html = data['html'];
          
          showNoteDialog(context, html);
        }

        if (type == 'anchor') {
          final String id = data['id'];
          
          injectScript('moegirl.method.link.gotoAnchor(\'$id\', -${widget.contentTopPadding})');
        }

        if (type == 'notExist') {
          showAlert<bool>(content: Lang.pageNameMissing);
        }

        if (type == 'edit') {
          final dynamic section = data['section'];
          final String pageName = data['pageName'];
          
          if (widget.disabledLink) return;
          if (!widget.editAllowed) {
            showAlert<bool>(content: Lang.insufficientPermissions);
            return;
          }

          if (!accountProvider.isLoggedIn) {
            final result = await showAlert<bool>(
              content: Lang.notLoggedInHint,
              visibleCloseButton: true
            );
            if (result) OneContext().pushNamed('/login');
            return;
          }

          final sectionStr = section is int ? section.toString() : null;
          final isNonautoConfirmed = await checkIfNonautoConfirmedToShowEditAlert(pageName, sectionStr);
          if (isNonautoConfirmed) return;

          OneContext().pushNamed('/edit', arguments: EditPageRouteArgs(
            pageName: pageName, 
            editRange: EditPageEditRange.section,
            section: sectionStr
          ));
        }

        if (type == 'watch') {

        }

        if (type == 'external') {
          final String url = data['url'];
          
          if (widget.disabledLink) return;
          launch(url);
        }

        if (type == 'externalImg') {
          final String url = data['url'];
          
          OneContext().pushNamed('/imagePreviewer', arguments: ImagePreviewerPageRouteArgs(
            images: [MoegirlImage(fileUrl: url)],
            initialIndex: 0
          ));
        }

        if (type == 'unparsed') {}
      },

      'contentsData': (data) {
        if (widget.emitContentData != null) widget.emitContentData(data);
      },

      'loaded': (_) {
        if (articleHtml != '') {
          setState(() => status = 3);
          if (widget.onArticleRendered != null) widget.onArticleRendered();
        }
      },

      'pageHeightChange': (height) {
        setState(() => contentHeight = height);
      },

      'biliPlayer': (data) {
        final String type = data['type']; // 'av' | 'bv'
        final String videoId = data['videoId'];
        final int page = data['page'];
        
        launch('https://www.bilibili.com/video/$type$videoId?p=$page');
      },

      'biliPlayerLongPress': (data) {

      },

      'request': (data) async {
        final String url = data['url'];
        final String method = data['method'];
        final dynamic requestData = data['data'];
        final int callbackId = data['callbackId'];
        
        try {
          final res = await plainRequest.request(url,
            queryParameters: method != 'post' ? requestData : null,
            data: method == 'post' ? requestData : null,
            options: Options(
              method: method
            )
          );

          injectScript('moegirl.config.request.callbacks[\'$callbackId\'].resolve(${jsonEncode(res.data)})');
        } catch(e) {
          print(e);
          injectScript('moegirl.config.request.callbacks[\'$callbackId\'].reject(${jsonEncode(e)})');
        }
      },

      'vibrate': (data) {
        // Vibration.vibrate();
      },

      'poll': (data) async {
        final String pollId = data['pollId'];
        final int answer = data['answer'];
        final String token = data['token'];
        try {
          final willUpdateContent = (await AccountApi.poll(pollId, answer, token))['content'];
          final encodedeContent = await encodeJsEvalCodes(willUpdateContent);
          injectScript('moegirl.method.poll.updatePollContent(\'$pollId\', \'$encodedeContent\')');
        } catch(e) {
          print('投票失败');
          print(e);
        }
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
            injectedFiles: ['main.css', 'main.js'],
            injectedStyles: injectedStyles,
            injectedScripts: injectedScripts,
            injectedScriptsFirst: ['window.RLQ = []'],
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
                  child: Text(Lang.reload,
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
  final Future<dynamic> Function(String script) injectScript;
  InAppWebViewController Function() getWebViewController;
  
  ArticleViewController(this.reload, this.injectScript, this.getWebViewController);
}

class MoegirlImage {
  final String fileName;
  final String title;
  String fileUrl;

  MoegirlImage({
    this.fileName = '',
    this.title = '',
    this.fileUrl = ''
  });

  MoegirlImage.fromMap(Map map) :
    fileName = map['fileName'],
    title = map['title']
  ;
}