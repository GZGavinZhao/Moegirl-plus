// @dart=2.9
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/database/backup.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/comment.dart';
import 'package:moegirl_plus/utils/check_is_login.dart';
import 'package:moegirl_plus/utils/debounce.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/comment/components/item.dart';
import 'package:moegirl_plus/views/comment/components/item_animation.dart';
import 'package:moegirl_plus/views/comment/utils/show_comment_editor/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  
  final listController = ItemScrollController();
  final Map<String, CommentPageItemAnimationController> itemAnimationControllers = {};
  final Map<String, GlobalKey> itemKeys = {};

  @override
  void initState() { 
    super.initState();
    commentData['children'].forEach((item) => itemKeys[item['id']] = GlobalKey());
  }

  void addReply([String initialValue = '']) async {
    await checkIsLogin(Lang.replyLoginHint);
    
    final indexForBackup = widget.routeArgs.pageId.toString() + widget.routeArgs.commentId.toString();
    final backupContent = (text) => BackupDbClient.set(BackupType.comment, indexForBackup, text);

    // 获取备份，如果有
    var cachedValue = await BackupDbClient.get(BackupType.comment, indexForBackup);
    cachedValue ??= BackupData(content: '');
    initialValue = initialValue != '' ? initialValue : cachedValue.content;

    final commentContent = await showCommentEditor(
      targetName: commentData['username'],
      initialValue: initialValue,
      isReply: true,
      onChanged: debounce(backupContent, Duration(seconds: 2))
    );
    if (commentContent == null) return;
    showLoading(text: Lang.submitting + '...');
    try {
      await commentProvider.addComment(widget.routeArgs.pageId, commentContent, commentId);
      toast(Lang.published, position: ToastPosition.center);
      BackupDbClient.delete(BackupType.comment, indexForBackup);
    } catch(e) {
      if (!(e is DioError)) rethrow;
      print('添加回复失败');
      print(e);
      toast(Lang.netErr, position: ToastPosition.center);
      Future.microtask(() => addReply(commentContent));
    } finally {
      OneContext().pop();
    }
  }

  void focusItem(String commentId, int index) {
    itemAnimationControllers[commentId].show();
    listController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 200),
      curve: Curves.ease
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget headerWidget() => (
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
            child: Text(Lang.replyTotal(commentData['children'].length),
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 17
              ),
            ),
          )
        ],
      )
    );

    Widget footerWidget() => (
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20).copyWith(top: 19),
        child: Text(Lang.noMore,
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 17
          )
        ),
      )
    );
                            
    return Selector<CommentProviderModel, Map>(
      selector: (_, provider) => provider.findByCommentId(
        widget.routeArgs.pageId,
        widget.routeArgs.commentId
      ),
      builder: (_, replyData, __) => (
        Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: AppBarTitle('${Lang.reply}：${replyData['username']}'),
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
                    ScrollablePositionedList.builder(
                      itemScrollController: listController,
                      itemCount: commentData['children'].length + 2,
                      itemBuilder: (context, index) {
                        if (index == 0) return headerWidget();
                        if (index == commentData['children'].length + 1) return footerWidget();

                        final itemData = commentData['children'].reversed.toList()[index - 1];
                        return  CommentPageItem(
                          key: itemKeys[itemData['id']],
                          pageId: pageId,
                          commentData: itemData,
                          rootCommentId: commentId,
                          visibleRpleyButton: true,
                          visibleDelButton: accountProvider.userName == itemData['username'],
                          emitAnimationController: (controller) => itemAnimationControllers[itemData['id']] = controller,
                          onTargetUserNamePressed: (id) => focusItem(id, index - 1),
                        );
                      },
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