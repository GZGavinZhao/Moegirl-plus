import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/app_bar_icon.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:one_context/one_context.dart';

class ArticlePageRouteArgs {
  final String pageName;
  final String displayPageName;
  final String anchor;

  ArticlePageRouteArgs({
    @required this.pageName, 
    this.displayPageName, 
    this.anchor 
  });
}

class ArticlePage extends StatefulWidget {
  final ArticlePageRouteArgs routeArgs;
  
  ArticlePage(this.routeArgs, {Key key}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ArticlePageRouteArgs routeArgs;
  String truePageName;
  String displayPageName;
  int pageId;
  dynamic contentsData;
  bool isWatched = false;

  @override
  void initState() {
    super.initState();
    truePageName = widget.routeArgs.pageName;
    displayPageName = widget.routeArgs.displayPageName ?? widget.routeArgs.pageName;
  }

  void articleDataLoaded(dynamic articleData) {
    final parse = articleData['parse'];
    setState(() {
      truePageName = parse['title'];
      displayPageName = parse['displaytitle'];
      pageId = parse['pageid'];
      contentsData = parse['sections'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(displayPageName),
        leading: Builder(
          builder: (context) => appBarIcon(Icons.arrow_back, () => OneContext().pop())
        ),
        actions: [
          appBarIcon(Icons.search, () => OneContext().pushNamed('search'))
        ],
      ),
      body: Container(
        child: ArticleView(
          pageName: truePageName,
          onArticleLoaded: articleDataLoaded,
        ),
      )
    );
  }
}