import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/article.dart';
import 'package:moegirl_viewer/api/watch_list.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/comment.dart';
import 'package:moegirl_viewer/providers/settings.dart';
import 'package:moegirl_viewer/utils/check_if_nonauto_confirmed_to_show_edit_alert.dart';
import 'package:moegirl_viewer/utils/provider_change_checker.dart';
import 'package:moegirl_viewer/utils/reading_history_manager.dart';
import 'package:moegirl_viewer/utils/route_aware.dart';
import 'package:moegirl_viewer/utils/status_bar_height.dart';
import 'package:moegirl_viewer/utils/ui/dialog/alert.dart';
import 'package:moegirl_viewer/utils/ui/dialog/loading.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/article/components/header/index.dart';
import 'package:moegirl_viewer/views/comment/index.dart';
import 'package:moegirl_viewer/views/drawer/index.dart';
import 'package:moegirl_viewer/views/edit/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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

  // 编辑后返回这个页面检查这个字段，如果为真则reload
  static bool popNextReloadMark = false;

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> with 
  RouteAware, 
  SubscriptionForRouteAware,
  ProviderChangeChecker 
{
  ArticlePageRouteArgs routeArgs;
  String truePageName;
  String displayPageName;
  int pageId;
  List contentsData;

  Map pageInfo;
  bool isWatched = false;
  bool visibleCommentButton = false;  // 只有主空间和用户页显示评论
  bool editAllowed = false; // 权限不足将无法编辑
  bool editFullDisabled = false; // 讨论页禁止编辑全文

  bool enabledHeaderMoreButton = false; // 加载完毕确认条目真实存在之前禁用更多按钮
  // 这里要存一个不变的值，防止用户改变stopAudioOnLeave的设置后，前后值不一致造成麻烦
  final stopAudioOnLeave = settingsProvider.stopAudioOnLeave;
  // 用于编程式打开条目目录
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ArticlePageHeaderAnimationController headerController;
  ArticlePageCommentButtonAnimationMainController commentButtonController;
  ArticleViewController articleViewController;

  @override
  void initState() {
    super.initState();
    truePageName = widget.routeArgs.pageName;
    displayPageName = widget.routeArgs.displayPageName ?? widget.routeArgs.pageName;

    // 监听评论状态变化，播放评论按钮ripple动画
    addChangeChecker<CommentProviderModel, num>(
      provider: commentProvider, 
      selector: (provider) => provider.data[pageId]?.status ?? 1,
      shouldExec: (prevVal, newVal) => prevVal == 2.1 && newVal >= 3,
      handler: (value) {
        commentButtonController.ripple();
      }
    );
  }

  @override
  void didPushNext() {
    super.didPush();
    
    if (stopAudioOnLeave) {
      articleViewController.injectScript([
        pauseAllAudioJsStr,
        disableAllIframeJsStr
      ].join(';'));
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    
    headerController.show();

    if (stopAudioOnLeave) {
      articleViewController.injectScript(enableAllIframeJsStr);
    }

    if(ArticlePage.popNextReloadMark) {
      ArticlePage.popNextReloadMark = false;
      articleViewController.reload(true);
    }
  }

  void articleDataWasLoaded(dynamic articleData) async {
    final parse = articleData['parse'];
    setState(() {
      truePageName = parse['title'];
      displayPageName = parse['displaytitle'];
      pageId = parse['pageid'];
      enabledHeaderMoreButton = true;
    });

    await getPageInfo(truePageName);

    if (visibleCommentButton) {
      if (commentProvider.data[pageId] == null) {
        commentProvider.loadNext(pageId);
      }

      commentButtonController.show();
    }
    
    ReadingHistoryManager.add(truePageName, widget.routeArgs.pageName);
  }

  void articleWasMissed(String pageName) async {
    await showAlert(content: '该条目或用户页还未创建');
    OneContext().pop();
  }

  Future<void> getPageInfo(String pageName) async {
    try {
      final Map pageInfo = await ArticleApi.getPageInfo(pageName);
      final userInfo = await accountProvider.getUserInfo();

      bool editAllowed;
      final isUnprotectednessPage = pageInfo['protection'].length == 0;
      final isTalkPage = [1, 11, 3, 5, 7, 9, 13, 15, 275, 711, 829, 2301, 2303].contains(pageInfo['ns']);
      final isSysop = userInfo['groups'].contains('sysop');
      final isPatroller = userInfo['groups'].contains('patroller');
      if (isUnprotectednessPage || isTalkPage || isSysop) {
        editAllowed = true;
      } else if(isPatroller) {
        final isPatrollerAllowed = pageInfo['protection'].singleWhere((item) => item['type'] == 'edit', orElse: () => {})['level'] == 'patrolleredit';
        editAllowed = isPatrollerAllowed;
      } else {
        editAllowed = false;
      }
      
      setState(() {
        isWatched = pageInfo.containsKey('watched');
        // 只在：主、用户、分类 命名空间显示评论
        visibleCommentButton = [0, 2, 14].contains(pageInfo['ns']);
        this.editAllowed = editAllowed;
        this.editFullDisabled = isTalkPage;
      });
    } catch(e) {
      // 获取页面信息失败不会导致无法浏览条目
      print('获取页面信息失败');
      print(e);
    }
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
      final isNonautoConfirmed = await checkIfNonautoConfirmedToShowEditAlert(truePageName);
      if (isNonautoConfirmed) return;
      
      OneContext().pushNamed('/edit', arguments: EditPageRouteArgs(
        editRange: EditPageEditRange.full,
        pageName: truePageName,
      ));
    }
    if (value == ArticlePageHeaderMoreMenuValue.addSection) {
      final isNonautoConfirmed = await checkIfNonautoConfirmedToShowEditAlert(truePageName, 'new');
      if (isNonautoConfirmed) return;

      OneContext().pushNamed('/edit', arguments: EditPageRouteArgs(
        editRange: EditPageEditRange.section,
        pageName: truePageName,
        section: 'new'
      ));
    }
    if (value == ArticlePageHeaderMoreMenuValue.login) {
      OneContext().pushNamed('/login');
    }
    if (value == ArticlePageHeaderMoreMenuValue.toggleWatchList) {
      try {
        showLoading();
        await WatchListApi.setWatchStatus(truePageName, !isWatched);
        toast('已${isWatched ? '移出' : '加入'}监视列表');
        setState(() => isWatched = !isWatched);
      } catch(e) {
        toast(e.toString());
      } finally {
        OneContext().pop();
      }
    }
    if (value == ArticlePageHeaderMoreMenuValue.share) {
      Share.share('萌娘百科 - ${widget.routeArgs.pageName} https://mzh.moegirl.org.cn/index.php?curid=$pageId', subject: '萌娘百科分享');
    }
    if (value == ArticlePageHeaderMoreMenuValue.openContents) {
      scaffoldKey.currentState.openEndDrawer();
    }
  }

  void commentButtonWasPressed() {
    final currentCommentData = commentProvider.data[pageId];
    if (currentCommentData.status == 0) {
      commentProvider.loadNext(pageId);
      return;
    }
    if ([2, 2.1].contains(currentCommentData.status)) {
      toast('加载中');
      return;
    }
    OneContext().pushNamed('/comment', arguments: CommentPageRouteArgs(
      pageName: truePageName, 
      pageId: pageId
    ));
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
      key: scaffoldKey,
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
              emitContentData: (data) => setState(() => contentsData = data),
              onArticleMissed: articleWasMissed,
              emitArticleController: (controller) => articleViewController = controller,
            ),

            Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: ArticlePageHeader(
                title: displayPageName,
                isExistsInWatchList: isWatched,
                editAllowed: editAllowed,
                enabledMoreButton: enabledHeaderMoreButton,
                editFullDisabled: editFullDisabled,
                onMoreMenuPressed: headerMoreMenuWasPressed,
                emitController: (controller) => headerController = controller,
              ),
            ),

            Positioned(
              right: 20,
              bottom: 20,
              child: Offstage(
                offstage: !visibleCommentButton,
                child: ArticlePageCommentButton(
                  text: commentButtonText,
                  emitController: (controller) => commentButtonController = controller,
                  onPressed: commentButtonWasPressed
                ),
              )
            )
          ],
        )
      )
    );
  }
}

const disableAllIframeJsStr = '''
  (() => {
    const iframeList = document.querySelectorAll('iframe')
    iframeList.forEach(item => {
      // 通过清空src的方式停止播放
      const src = item.src
      item.src = ''
      item.dataset.src = src
    })
  })()
''';

const enableAllIframeJsStr = '''
  (() => {
    const iframeList = document.querySelectorAll('iframe')
    iframeList.forEach(item => {
      item.src = item.dataset.src
    })
  })()
''';

const pauseAllAudioJsStr = '''
  (() => {
    const audioList = document.querySelectorAll('audio')
    audioList.forEach(item => item.pause())
  })()
''';