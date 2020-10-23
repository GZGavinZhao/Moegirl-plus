import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/watchList.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:moegirl_viewer/providers/comment.dart';
import 'package:moegirl_viewer/utils/reading_history_manager.dart';
import 'package:moegirl_viewer/utils/route_aware.dart';
import 'package:moegirl_viewer/utils/status_bar_height.dart';
import 'package:moegirl_viewer/utils/ui/dialog/index.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/article/components/header/index.dart';
import 'package:moegirl_viewer/views/drawer/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import 'components/comment_button/index.dart';
import 'components/contents/index.dart';
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

class _ArticlePageState extends State<ArticlePage> with RouteAware, SubscriptionForRouteAware {
  ArticlePageRouteArgs routeArgs;
  String truePageName;
  String displayPageName;
  int pageId;
  dynamic contentsData;
  bool isWatched = false;
  num lastCommentStatus = 1;

  ArticlePageHeaderAnimationController headerController;
  ArticlePageCommentButtonAnimationMainController commentButtonController;
  ArticleViewController articleViewController;

  @override
  void initState() {
    super.initState();
    truePageName = widget.routeArgs.pageName;
    displayPageName = widget.routeArgs.displayPageName ?? widget.routeArgs.pageName;
    
    getWatchingStatus(truePageName);

    commentProvider.addListener(commentStatusListener);
  }

  @override
  void dispose() { 
    commentProvider.removeListener(commentStatusListener);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    headerController.show();
  }

  // 监听评论状态变化，播放评论按钮ripple动画
  void commentStatusListener() {
    final newCommentStatus = commentProvider.data[pageId].status;
    if (lastCommentStatus == newCommentStatus) return;
    if (lastCommentStatus == 2.1 && newCommentStatus >= 3) {
      commentButtonController.ripple();
    }

    lastCommentStatus = newCommentStatus;
  }

  void articleDataWasLoaded(dynamic articleData) {
    final parse = articleData['parse'];
    setState(() {
      truePageName = parse['title'];
      displayPageName = parse['displaytitle'];
      pageId = parse['pageid'];
    });

    lastCommentStatus = commentProvider.data[pageId]?.status ?? 1;

    if (commentProvider.data[pageId] == null) {
      commentProvider.loadNext(pageId);
    }
    
    commentButtonController.show();
    ReadingHistoryManager.add(truePageName, displayPageName);
  }

  void getWatchingStatus(String pageName) async {
    final isWatched = await WatchList.isWatched(pageName);
    setState(() => this.isWatched = isWatched);
  }

  double lastScrollY = 0;
  void webViewScrollWasChanged(dynamic scrollY) {
    if (scrollY < 100) {
      headerController.show();
      commentButtonController.show();
    } else if (lastScrollY < scrollY) {
      headerController.hide();
      commentButtonController.hide();
    } else {
      headerController.show();
      commentButtonController.show();
    }

    lastScrollY = scrollY;
  }

  void headerMoreMenuWasPressed(ArticlePageHeaderMoreMenuValue value) async {
    if (value == ArticlePageHeaderMoreMenuValue.refresh) {
      articleViewController.reload(true);
    }
    if (value == ArticlePageHeaderMoreMenuValue.edit) {

    }
    if (value == ArticlePageHeaderMoreMenuValue.login) {
      OneContext().pushNamed('/login');
    }
    if (value == ArticlePageHeaderMoreMenuValue.toggleWatchList) {
      try {
        CommonDialog.loading();
        await WatchList.setWatchStatus(truePageName, !isWatched);
        toast('已${isWatched ? '移出' : '加入'}监视列表');
        setState(() => isWatched = !isWatched);
      } catch(e) {
        toast(e.toString());
      } finally {
        CommonDialog.popDialog();
      }
    }
    if (value == ArticlePageHeaderMoreMenuValue.share) {

    }
    if (value == ArticlePageHeaderMoreMenuValue.openContents) {
      
    }
  }

  void commentButtonWasPressed() {
    final comment = Provider.of<CommentProviderModel>(context);
    final currentCommentData = comment.data[pageId];
    if (currentCommentData.status == 0) {
      comment.loadNext(pageId);
      return;
    }
    if ([2, 2.1].contains(currentCommentData.status)) {
      toast('加载中');
      return;
    }
    OneContext().pushNamed('/comment');
  }

  void jumpToAnchor(String anchor) {
    final minusOffset = kToolbarHeight + statusBarHeight;
    articleViewController.injectScript('moegirl.method.link.gotoAnchor("$anchor", -$minusOffset)');
  }

  final injectedWindowScrollEventHandlerStr = '''
    window.onscroll = () => _postMessage('windowScrollChange', window.scrollY)
  ''';

  String get commentButtonText {
    final currentCommentData = Provider.of<CommentProviderModel>(context).data[pageId];
    var text = '...';
    if (currentCommentData != null) {
      if (currentCommentData.status == 0) text = '×';
      if (currentCommentData.status >= 3) text = currentCommentData.count.toString();
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final contentTopPadding = kToolbarHeight + statusBarHeight;
    
    return Scaffold(
      drawer: GlobalDrawer(),
      endDrawer: ArticlePageContents(
        contentsData: contentsData,
        onSectionPressed: jumpToAnchor,
      ),
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
              onArticleLoaded: articleDataWasLoaded,
              onContentDataEmited: (data) => setState(() => contentsData = data),
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

            Positioned(
              right: 20,
              bottom: 20,
              child: ArticlePageCommentButton(
                text: commentButtonText,
                emitController: (controller) => commentButtonController = controller,
                onPressed: commentButtonWasPressed
              )
            )
          ],
        )
      )
    );
  }
}