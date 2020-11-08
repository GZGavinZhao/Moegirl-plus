import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/components/structured_list_view.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/comment.dart';
import 'package:moegirl_viewer/utils/ui/dialog/loading.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/comment/components/item.dart';
import 'package:moegirl_viewer/views/comment/utils/show_comment_editor/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class CommentReplyPageRouteArgs {
  final int pageId;
  final String commentId;
  
  CommentReplyPageRouteArgs({
    this.pageId,
    this.commentId
  });
}

class CommentReplyPage extends StatefulWidget {
  final CommentReplyPageRouteArgs routeArgs;
  CommentReplyPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _CommentReplyPageState createState() => _CommentReplyPageState();
}

class _CommentReplyPageState extends State<CommentReplyPage> {
  int get pageId => widget.routeArgs.pageId;
  String get commentId => widget.routeArgs.commentId;
  Map get commentData => commentProvider.findByCommentId(pageId, commentId);
  
  void addReply() async {
    final commentContent = await showCommentEditor(
      targetName: commentData['username'],
      isReply: true
    );
    if (commentContent == null) return;
    showLoading(text: '提交中...');
    try {
      await commentProvider.addComment(widget.routeArgs.pageId, commentContent, commentId);
      toast('发布成功', position: ToastPosition.center);
    } catch(e) {
      if (!(e is DioError)) rethrow;
      print('添加回复失败');
      print(e);
      toast('网络错误', position: ToastPosition.center);
    } finally {
      OneContext().pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Selector<CommentProviderModel, Map>(
      selector: (_, provider) => provider.findByCommentId(
        widget.routeArgs.pageId,
        widget.routeArgs.commentId
      ),
      builder: (_, replyData, __) => (
        Scaffold(
          appBar: AppBar(
            title: Text('回复：${replyData['username']}'),
            actions: [AppBarIcon(icon: Icons.reply, onPressed: addReply)],
            elevation: 0,
          ),
          body: NightSelector(
            builder: (isNight) => (
              Container(
                color: isNight ? theme.backgroundColor : Color(0xffeeeeee),
                child: Selector<CommentProviderModel, int>(
                  selector: (_, provider) => provider.findByCommentId(pageId, commentId)['children'].length,
                  builder: (_, __, ___) => (
                    StructuredListView(
                      itemDataList: commentData['children'],
                      reverse: true,
                      
                      headerBuilder: () => (
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommentPageItem(
                              isReply: true,
                              pageId: pageId,
                              commentData: commentData,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10).copyWith(top: 9),
                              child: Text('共${commentData['children'].length}条回复',
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 17
                                ),
                              ),
                            )
                          ],
                        )
                      ),

                      itemBuilder: (_, itemData) => (
                        CommentPageItem(
                          pageId: pageId,
                          commentData: itemData,
                          rootCommentId: commentId,
                          visibleRpleyButton: true,
                          visibleDelButton: accountProvider.userName == itemData['username'],
                        )
                      ),

                      footerBuilder: () => (
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 20).copyWith(top: 19),
                          child: Text('已经没有啦',
                            style: TextStyle(
                              color: theme.disabledColor,
                              fontSize: 17
                            )
                          ),
                        )
                      ),
                    )
                  ),
                ),
              )
            )
          ),
        )
      ),
    );
  }
}