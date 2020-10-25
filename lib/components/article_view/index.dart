
import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:moegirl_viewer/api/article.dart';
import 'package:moegirl_viewer/components/article_view/utils/create_moegirl_renderer_config.dart';
import 'package:moegirl_viewer/components/article_view/utils/get_article_content_from_cache.dart';
import 'package:moegirl_viewer/components/html_web_view/index.dart';
import 'package:moegirl_viewer/components/indexedView.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/settings.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/request/plain_request.dart';
import 'package:moegirl_viewer/themes.dart';
import 'package:moegirl_viewer/utils/article_cache_manager.dart';
import 'package:moegirl_viewer/utils/color2rgb_css.dart';
import 'package:moegirl_viewer/utils/provider_change_checker.dart';
import 'package:moegirl_viewer/utils/ui/dialog/index.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/image_previewer/index.dart';
import 'package:one_context/one_context.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../styled_widgets/circular_progress_indicator.dart';
import 'utils/show_note_dialog.dart';

final moegirlRendererJsFuture = rootBundle.loadString('assets/main.js');
final moegirlRendererCssFuture = rootBundle.loadString('assets/main.css');

class ArticleView extends StatefulWidget {
  final String pageName;
  final String html;
  final List<String> injectedStyles;
  final List<String> injectedScripts;
  final bool disabledLink;
  final bool fullHeight;
  final bool inDialogMode;
  final double contentTopPadding;
  final Map<String, void Function(dynamic data)> messageHandlers;
  final void Function(ArticleViewController) emitArticleController;
  final void Function(dynamic contentsData) onContentDataEmited;
  final void Function(dynamic articleData) onArticleLoaded;
  final void Function(String pageName) onArticleMissing;
  final void Function(String pageName) onArticleError;

  ArticleView({
    Key key,
    this.pageName,
    this.html,
    this.injectedStyles = const [],
    this.injectedScripts = const [],
    this.disabledLink = false,
    this.fullHeight = false,
    this.inDialogMode = false,
    this.contentTopPadding = 0,
    this.messageHandlers = const {},
    this.emitArticleController,
    this.onContentDataEmited,
    this.onArticleLoaded,
    this.onArticleMissing,
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
  double containerHeight = maxContainerHeight;

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
        injectScript('moegirl.config.nightTheme.\$enabled = ${isNightTheme.toString()}');
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
    final canUseCache = pageName.contains(RegExp(r'^([Cc]ategory|分类|分類|[Tt]alk|.+ talk):'));

    if (!forceLoad && canUseCache && settingsProvider.cachePriority) {
      final articleCache = await ArticleCacheManager.getCache(pageName);
      if (articleCache != null) {
        updateWebHtmlView(articleCache);

        // 后台请求一次文章数据，更新缓存
        getArticleContentFromRamCache(pageName)
          .then((data) {
            final trueTitle = data.parse.title;
            ArticleCacheManager.addCache(pageName, trueTitle);
          });
        return;
      }
    }

    try {
      final articleData = await getArticleContentFromRamCache(pageName, forceLoad);

      // 如果是分类页则跳转
      if (pageName.contains(RegExp(r'^([Cc]ategory|分类|分類):'))) {
        final htmlDoc = parse(articleData['parse']['text']['*']);
        final categoriesContainer = htmlDoc.getElementById('topicpath');
        final descContainer = htmlDoc.getElementById('catmore');
        List<String> categories;
        String categoryArticleTitle;

        if (categoriesContainer != null) {
          categories = categoriesContainer.getElementsByTagName('a').map((e) => e.text);
        }

        if (descContainer != null) {
          categoryArticleTitle = descContainer.getElementsByTagName('a')[0].attributes['title'];
        }

        OneContext().pushReplacementNamed('category', arguments: {
          'title': pageName.replaceFirst(RegExp(r'^([Cc]ategory|分类|分類):'), ''),
          'categories': categories,
          'categoryArticleTitle': categoryArticleTitle
        });

        return;
      }

      if (widget.onArticleLoaded != null) widget.onArticleLoaded(articleData);
      loadImgOriginalUrls(
        articleData['parse']['images'].cast<String>()
          .where((String e) => e.contains(RegExp(r'/\.svg$/')) == false)
          .toList()
      )
        .catchError((e) {
          print('文章图片原始链接获取失败');
          print(e);
        });

      final trueTitle = articleData['parse']['title'];
      await ArticleCacheManager.addCache(trueTitle, articleData)
        .catchError((e) {
          print('添加文章缓存失败');
          print(e);
        });
      return updateWebHtmlView(articleData);
    } catch(e) {
      print('加载文章数据失败');
      if (!(e is DioError) && !(e is MoeRequestError)) rethrow;
      if (e is MoeRequestError && widget.onArticleMissing != null) widget.onArticleMissing(pageName);
      if (e.type is DioErrorType) {
        final articleCache = await ArticleCacheManager.getCache(pageName);
        if (articleCache != null) {
          toast('加载文章失败，载入缓存');
          if (widget.onArticleLoaded != null) widget.onArticleLoaded(articleCache);
          return updateWebHtmlView(articleCache);
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
    setState(() => containerHeight = maxContainerHeight);
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

  // 里面引用了widget，不使用函数编译器不给过
  Map<String, void Function(dynamic data)> messageHandlers() {
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
            CommonDialog.loading(
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
              CommonDialog.popDialog();
            }
          }

          OneContext().pushNamed('imagePreviewer', arguments: ImagePreviewerPageRouteArgs(
            imageUrl: imageUrl
          ));
        }

        if (type == 'note') {
          showNoteDialog(data['html']);
        }

        if (type == 'anchor') {
          injectScript('moegirl.method.link.gotoAnchor(\'${data['id']}\', -${widget.contentTopPadding})');
        }

        if (type == 'notExist') {
          CommonDialog.alert(content: '该条目还未创建');
        }

        if (type == 'edit') {
          if (widget.disabledLink) return;
          if (accountProvider.isLoggedIn) {
            // OneContext().pushNamed('/edit', args: )
          } else {
            final result = await CommonDialog.alert(
              content: '登录后才可以进行编辑，要前往登录界面吗？'
            );
            if (result) OneContext().pushNamed('/login');
          }
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
        if (widget.onContentDataEmited != null) widget.onContentDataEmited(data);
      },

      'loaded': (_) {
        if (articleHtml != '') setState(() => status = 3);
      },

      'pageHeightChange': (height) {
        if (status == 3) setState(() => containerHeight = height);
      },

      'biliPlayer': (data) {
        
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
        Vibration.vibrate();
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
    return Container(
      alignment: Alignment.center,
      height: widget.fullHeight ? containerHeight : null,
      child: IndexedStack(
        index: status == 3 ? 0 : 1,
        children: [
          HtmlWebView(
            body: articleHtml, 
            title: widget.pageName,
            injectedStyles: injectedStyles,
            injectedScripts: injectedScripts,
            messageHandlers: {
              ...messageHandlers(),
              ...widget.messageHandlers
            },
            onWebViewCreated: (controller) => htmlWebViewController = controller,
          ),

          Container(
            alignment: Alignment.center,
            child: IndexedView(
              index: status,
              builders: {
                0: () => Container(
                 margin: EdgeInsets.only(top: widget.contentTopPadding),
                  child: TextButton(
                    child: Text('重新加载',
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    onPressed: () => reload(true),
                  ),
                ),
                2: () => Container(
                  margin: EdgeInsets.only(top: widget.contentTopPadding),
                  child: StyledCircularProgressIndicator(),
                ),
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