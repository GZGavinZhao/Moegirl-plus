import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/structured_list_view.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/comment.dart';
import 'package:moegirl_plus/utils/check_is_login.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/comment/components/item.dart';
import 'package:moegirl_plus/views/comment/utils/show_comment_editor/index.dart';
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
  
  void addReply([String initialValue = '']) async {
    await checkIsLogin();
    
    final commentContent = await showCommentEditor(
      targetName: commentData['username'],
      initialValue: initialValue,
      isReply: true
    );
    if (commentContent == null) return;
    showLoading(text: l.submitting);
    try {
      await commentProvider.addComment(widget.routeArgs.pageId, commentContent, commentId);
      toast(l.replayPage_published, position: ToastPosition.center);
    } catch(e) {
      if (!(e is DioError)) rethrow;
      print('添加回复失败');
      print(e);
      toast(l.netErr, position: ToastPosition.center);
      Future.microtask(() => addReply(commentContent));
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
            title: Text('${l.replayPage_title}：${replyData['username']}'),
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
                              child: Text(l.replayPage_replayTotal(commentData['children'].length),
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 17
                                ),
                              ),
                            )
                          ],
                        )
                      ),

                      itemBuilder: (_, itemData, index) => (
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
                          child: Text(l.replayPage_empty,
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