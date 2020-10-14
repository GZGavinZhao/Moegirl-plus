import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/watchList.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:moegirl_viewer/components/html_web_view/index.dart';
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
  ArticleViewController articleViewController;

  @override
  void initState() {
    super.initState();
    truePageName = widget.routeArgs.pageName;
    displayPageName = widget.routeArgs.displayPageName ?? widget.routeArgs.pageName;
    getWatchingStatus(truePageName);
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

  void getWatchingStatus(String pageName) async {
    final isWatched = await WatchList.isWatched(pageName);
    setState(() => this.isWatched = isWatched);
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

  void headerMoreMenuWasPressed(ArticlePageHeaderMoreMenuValue value) {
    if (value == ArticlePageHeaderMoreMenuValue.refresh) {
      articleViewController.reload(true);
    }
    if (value == ArticlePageHeaderMoreMenuValue.edit) {

    }
    if (value == ArticlePageHeaderMoreMenuValue.login) {

    }
    if (value == ArticlePageHeaderMoreMenuValue.toggleWatchList) {

    }
    if (value == ArticlePageHeaderMoreMenuValue.share) {

    }
    if (value == ArticlePageHeaderMoreMenuValue.openContents) {
      
    }
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
              emitArticleController: (controller) => articleViewController = controller,
            ),

            Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: ArticlePageHeader(
                title: displayPageName,
                isExistsInWatchList: isWatched,
                onMoreMenuPressed: headerMoreMenuWasPressed,
                emitController: (controller) => headerController = controller,
              ),
            ),
          ],
        )
      )
    );
  }
}