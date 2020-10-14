
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:moegirl_viewer/api/article.dart';
import 'package:moegirl_viewer/components/article_view/utils/create_moegirl_renderer_config.dart';
import 'package:moegirl_viewer/components/article_view/utils/get_article_content_from_cache.dart';
import 'package:moegirl_viewer/components/html_web_view/index.dart';
import 'package:moegirl_viewer/mobx/index.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/utils/article_cache_manager.dart';
import 'package:moegirl_viewer/utils/ui/dialog/index.dart';
import 'package:moegirl_viewer/utils/ui/selection_builder.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/image_previewer/index.dart';
import 'package:one_context/one_context.dart';
import 'package:webview_flutter/webview_flutter.dart';

final moegirlRendererJsFuture = rootBundle.loadString('assets/main.js');
final moegirlRendererCssFuture = rootBundle.loadString('assets/main.css');

class ArticleView extends StatefulWidget {
  final String pageName;
  final String html;
  final List<String> injectedStyles;
  final List<String> injectedScripts;
  final bool disabledLink;
  final bool fullHeight;
  final double contentTopPadding;
  final Map<String, void Function(dynamic data)> messageHandlers;
  final void Function(ArticleViewController) emitArticleController;
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
    this.contentTopPadding = 0,
    this.messageHandlers = const {},
    this.emitArticleController,
    this.onArticleLoaded,
    this.onArticleMissing,
    this.onArticleError
  }) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {  
  dynamic articleData;
  List<String> injectedStyles;
  List<String> injectedScripts;
  int status = 1;
  Map<String, String> imgOriginalUrls; 
  HtmlWebViewController htmlWebViewController;

  @override
  void initState() {
    super.initState();
    if (widget.pageName != null) {
      loadArticleContent(widget.pageName);
    } else {
      updateWebHtmlView();
    }

    if (widget.emitArticleController != null) {
      widget.emitArticleController(ArticleViewController(reload));
    }
  }
  
  Future loadArticleContent(String pageName, [bool forceLoad = false]) async {
    if (status == 2) return;
    
    setState(() { status = 2; });
    final canUseCache = pageName.contains(RegExp(r'^([Cc]ategory|分类|分類|[Tt]alk|.+ talk):'));

    if (!forceLoad && canUseCache) {
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
      if (e is NoSuchMethodError) rethrow;
      if (e is MoeRequestError && widget.onArticleMissing != null) widget.onArticleMissing(pageName);
      if (e.type is DioErrorType) {
        final articleCache = await ArticleCacheManager.getCache(pageName);
        if (articleCache != null) {
          toast('加载文章失败，载入缓存');
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
    await loadArticleContent(widget.pageName, forceLoad);
    htmlWebViewController.reload();
  }

  void updateWebHtmlView([dynamic articleData]) async {
    final moegirlRendererJs = await moegirlRendererJsFuture;
    final moegirlRendererCss = await moegirlRendererCssFuture;

    final categories = articleData != null ? articleData['parse']['categories'].map((e) => e['*']).toList().cast<String>() : <String>[];
    final moegirlRendererConfig = createMoegirlRendererConfig(
      pageName: widget.pageName,
      categories: categories,
      enbaledHeightObserver: widget.fullHeight
    );

    final styles = '''
      body {
        padding-top: ${widget.contentTopPadding}px;
      }
    ''';

    final isNightTheme = settingsStore.theme == 'night';
    final js = '''
      moegirl.config.heimu.\$enabled = ${settingsStore.heimu}
      moegirl.config.nightTheme.\$enabled = $isNightTheme
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
          final String imgName = data['name'].replaceFirst('_', ' ');
          if (imgName.contains(RegExp(r'\.svg$'))) {
            toast('无法预览svg图片');
            return;
          }

          String imageUrl;
          if (imgOriginalUrls != null) {
            imageUrl = imgOriginalUrls[imgName];
          } else {
            CommonDialog.loading();
            imageUrl = (await ArticleApi.getImagesUrl([imgName]))[imgName];
          }

          
          OneContext().pushNamed('imagePreviewer', arguments: ImagePreviewerPageRouteArgs(
            imageUrl: imageUrl
          ));
        }
      },

      'pageHeightChange': (height) {
        // if (!widget.fullHeight) return;
        // print('高度$height');
        // setState(() => contentHeight = height);
      },

      'loaded': (_) {
        if (articleHtml != '') setState(() => status = 3);
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
    return Container(
      alignment: Alignment.center,
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
            child: selectionBuilder(
              key: status,
              views: {
                0: () => TextButton(
                  child: Text('重新加载'),
                  onPressed: () => reload(true),
                ),
                2: () => Container(
                  margin: EdgeInsets.only(top: widget.contentTopPadding),
                  child: CircularProgressIndicator(),
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
  
  ArticleViewController(this.reload);
}