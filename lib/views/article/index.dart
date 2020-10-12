import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:moegirl_viewer/views/article/components/header/index.dart';
import 'package:moegirl_viewer/views/drawer/index.dart';

import 'components/header/components/animation.dart';
import 'components/header/index.dart';

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

  ArticlePageHeaderAnimationController headerController;

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

  double lastScrollY = 0;
  void webViewScrollWasChanged(dynamic scrollY) {
    if (scrollY < 100) {
      headerController.show();
    } else if (lastScrollY < scrollY) {
      print(headerController);
      headerController.hide();
    } else {
      headerController.show();
    }

    lastScrollY = scrollY;
  }

  final injectedWindowScrollEventHandlerStr = '''
    window.onscroll = () => _postMessage('windowScrollChange', window.scrollY)
  ''';

  @override
  Widget build(BuildContext context) {
    final contentTopPadding = kToolbarHeight + MediaQueryData.fromWindow(window).padding.top;
    
    return Scaffold(
      drawer: globalDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [            
            ArticleView(
              pageName: truePageName,
              contentTopPadding: contentTopPadding,
              injectedScripts: [injectedWindowScrollEventHandlerStr],
              messageHandlers: {
                'windowScrollChange': webViewScrollWasChanged
              },
              onArticleLoaded: articleDataLoaded,
            ),

            Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: ArticlePageHeader(
                title: displayPageName,
                onControllerCreated: (controller) => headerController = controller,
              ),
            ),
          ],
        )
      )
    );
  }
}