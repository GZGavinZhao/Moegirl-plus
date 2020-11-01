import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/indexedView.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/components/structured_list_view.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_viewer/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_viewer/components/styled_widgets/refresh_indicator.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/comment.dart';
import 'package:moegirl_viewer/utils/ui/dialog/loading.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/comment/components/item.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import 'utils/show_comment_editor/index.dart';

class CommentPageRouteArgs {
  final String pageName;
  final int pageId;

  CommentPageRouteArgs({
    @required this.pageName,  
    @required this.pageId
  });
}

class CommentPage extends StatefulWidget {
  final CommentPageRouteArgs routeArgs;
  CommentPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - scrollController.position.pixels < 200) {
        commentProvider.loadNext(widget.routeArgs.pageId);
      }
    });
  }

  @override
  void dispose() { 
    super.dispose();
    scrollController.dispose();
  }

  void addComment() async {
    final commentContent = await showCommentEditor(targetName: widget.routeArgs.pageName);
    if (commentContent == null) return;
    showLoading(text: '提交中...');
    try {
      await commentProvider.addComment(widget.routeArgs.pageId, commentContent);
      toast('发布成功', position: ToastPosition.center);
    } catch(e) {
      if (!(e is DioError)) rethrow;
      print('添加评论失败');
      print(e);
      toast('网络错误', position: ToastPosition.center);
    } finally {
      OneContext().popDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle('评论：${widget.routeArgs.pageName}'),
        leading: AppBarBackButton(),
        elevation: 0,
        actions: [AppBarIcon(icon: Icons.add_comment, onPressed: addComment)],
      ),
      body: NightSelector(
        builder: (isNight) => (
          Container(
            color: isNight ? theme.backgroundColor : Color(0xffeeeeee),
            child: Selector<CommentProviderModel, ProviderCommentData>(
              selector: (_, provider) => provider.data[widget.routeArgs.pageId],
              builder: (_, commentData, __) => (
                StyledRefreshIndicator(
                  onRefresh: () => commentProvider.refresh(widget.routeArgs.pageId),
                  child: StructuredListView(
                    controller: scrollController,
                    itemDataList: commentData.commentTree,

                    headerBuilder: () {
                      if (commentData.popular.length == 0) return Container(width: 0, height: 0);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('热门评论',
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          
                          ...commentData.popular.map((itemData) =>
                            CommentPageItem(
                              isPopular: true,
                              commentData: itemData,
                              pageId: widget.routeArgs.pageId,
                              visibleDelButton: accountProvider.userName == itemData['username'],
                              visibleRpleyButton: false,
                            )
                          ).toList(),

                          Padding(
                            padding: EdgeInsets.all(10).copyWith(top: 9),
                            child: Text('共${commentData.count}条评论',
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 17
                              ),
                            ),
                          )
                        ]
                      );
                    },
                    
                    itemBuilder: (context, itemData) => (
                      CommentPageItem(
                        commentData: itemData,
                        pageId: widget.routeArgs.pageId,
                        visibleDelButton: accountProvider.userName == itemData['username'],
                        visibleReply: true,
                        visibleRpleyButton: true,
                      )
                    ),

                    footerBuilder: () => IndexedView(
                      index: commentData.status, 
                      builders: {
                        0: () => CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => commentProvider.loadNext(widget.routeArgs.pageId),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text('加载失败，点击重试',
                              style: TextStyle(color: theme.hintColor),
                            ),
                          ),
                        ),

                        2: () => Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: StyledCircularProgressIndicator(),
                        ),

                        4: () => Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 20).copyWith(top: 19),
                          child: Text('已经没有啦',
                            style: TextStyle(
                              color: theme.disabledColor,
                              fontSize: 17
                            )
                          ),
                        ),

                        5: () => Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 20).copyWith(top: 19),
                          child: Text('暂无评论',
                            style: TextStyle(
                              color: theme.disabledColor,
                              fontSize: 17
                            )
                          ),
                        )
                      }
                    )
                  ),
                )
              ),
            ),
          )
        ),
      )
    );
  }
}