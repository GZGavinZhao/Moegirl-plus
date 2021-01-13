import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/infinity_list_footer.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/structured_list_view.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/components/styled_widgets/refresh_indicator.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/comment.dart';
import 'package:moegirl_plus/utils/add_infinity_list_loading_listener.dart';
import 'package:moegirl_plus/utils/check_is_login.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/comment/components/item.dart';
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
    addInfinityListLoadingListener(scrollController, () => commentProvider.loadNext(widget.routeArgs.pageId));
  }

  @override
  void dispose() { 
    super.dispose();
    scrollController.dispose();
  }

  void addComment([String initialValue = '']) async {
    await checkIsLogin();
    
    final commentContent = await showCommentEditor(targetName: widget.routeArgs.pageName, initialValue: initialValue);
    if (commentContent == null) return;
    showLoading(text: l.submitting);
    try {
      await commentProvider.addComment(widget.routeArgs.pageId, commentContent);
      toast(l.commentPage_submitted, position: ToastPosition.center);
    } catch(e) {
      if (!(e is DioError)) rethrow;
      print(l.commentPage_submitErr);
      print(e);
      toast(l.netErr, position: ToastPosition.center);
      Future.microtask(() => addComment(commentContent));
    } finally {
      OneContext().pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle('${l.commentPage_title}：${widget.routeArgs.pageName}'),
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
                            child: Text(l.commentPage_hotComment,
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
                            child: Text(l.commentPage_commentTotal(commentData.count),
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 17
                              ),
                            ),
                          )
                        ]
                      );
                    },
                    
                    itemBuilder: (context, itemData, index) => (
                      CommentPageItem(
                        commentData: itemData,
                        pageId: widget.routeArgs.pageId,
                        visibleDelButton: accountProvider.userName == itemData['username'],
                        visibleReply: true,
                        visibleRpleyButton: true,
                      )
                    ),

                    footerBuilder: () => InfinityListFooter(
                      status: commentData.status, 
                      emptyText: l.commentPage_empty,
                      onReloadingButtonPrssed: () => commentProvider.loadNext(widget.routeArgs.pageId)
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