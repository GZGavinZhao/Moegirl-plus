import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:moegirl_plus/api/comment.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/database/backup.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/comment.dart';
import 'package:moegirl_plus/utils/check_is_login.dart';
import 'package:moegirl_plus/utils/comment_tree.dart';
import 'package:moegirl_plus/utils/debounce.dart';
import 'package:moegirl_plus/utils/diff_date.dart';
import 'package:moegirl_plus/utils/trim_html.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/comment/components/item_animation.dart';
import 'package:moegirl_plus/views/comment/utils/show_comment_editor/index.dart';
import 'package:moegirl_plus/views/comment/views/reply/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

const replyHeaderHeroTag = 'replyHeaderHeroTag';

class CommentPageItem extends StatelessWidget {
  final Map commentData;
  final int pageId;
  final String rootCommentId;
  final bool isReply;
  final bool isPopular;
  final bool visibleReply;
  final bool visibleRpleyButton;
  final bool visibleDelButton;
  final void Function(String commentId) onReplyButtonPressed;
  final void Function(String targetCommentId) onTargetUserNamePressed;
  final void Function(CommentPageItemAnimationController) emitAnimationController;
  
  const CommentPageItem({
    @required this.commentData,
    @required this.pageId,
    this.rootCommentId,
    this.isReply = false,
    this.isPopular = false,
    this.visibleReply = false,
    this.visibleDelButton = false,
    this.visibleRpleyButton = false,
    this.onReplyButtonPressed,
    this.onTargetUserNamePressed,
    this.emitAnimationController,
    Key key
  }) : super(key: key);

  void toggleLike() async {
    await checkIsLogin(Lang.likeLoginHint);

    final isLiked = commentData['myatt'] == 1;
    showLoading();
    try {
      commentProvider.setLike(pageId, commentData['id'], !isLiked);
    } catch(e) {
      print('点赞操作失败');
      print(e);
      toast(Lang.netErr);
    } finally {
      OneContext().pop();
    }
  }

  void delComment() async {
    final result = await showAlert<bool>(
      content: Lang.delCommentHint(isReply),
      visibleCloseButton: true
    );

    if (!result) return;
    showLoading();
    try {
      await commentProvider.remove(pageId, commentData['id'], rootCommentId);
      toast(Lang.commentDeleted);
    } catch(e) {
      print('删除操作失败');
      print(e);
      toast(Lang.netErr);
    } finally {
      OneContext().pop();
    }
  }

  void replyComment([String initialValue = '']) async {
    await checkIsLogin(Lang.replyLoginHint);
    
    final indexForBackup = pageId.toString() + commentData['id'].toString();
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
      await commentProvider.addComment(pageId, commentContent, commentData['id']);
      toast(Lang.published, position: ToastPosition.center);
      BackupDbClient.delete(BackupType.comment, indexForBackup);
    } catch(e) {
      if (!(e is DioError)) rethrow;
      print('添加回复失败');
      print(e);
      toast(Lang.netErr, position: ToastPosition.center);
      Future.microtask(() => replyComment(commentContent));
    } finally {
      OneContext().pop();
    }
  }

  void report() async {
    final result = await showAlert<bool>(
      content: Lang.reportHint(isReply),
      visibleCloseButton: true
    );
    if (!result) return;

    showLoading();
    try {
      await CommentApi.report(commentData['id']);
      Future.microtask(() => showAlert<bool>(content: Lang.reoprtedHint));
    } catch(e) {
      print('举报评论失败');
      print(e);
      toast(Lang.netErr);
    } finally {
      OneContext().pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final replyList = commentData.containsKey('children') ? CommentTree.withTargetData(commentData['children'], commentData['id']) : [];
    
    return Hero(
      tag: commentData['id'] + (isPopular ? '-popular' : ''),
      child: Container(
        margin: EdgeInsets.only(bottom: 1),
        child: Material(
          color: theme.colorScheme.surface,
          child: InkWell(
            onTap: () {},
            child: CommentPageItemAnimation(
              emitController: emitAnimationController,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    // 头部
                    Stack(
                      children: [
                        Row(
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                                pageName: 'User:' + commentData['username']
                              )),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  image: DecorationImage(
                                    image: NetworkImage(avatarUrl + commentData['username'])
                                  )
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(commentData['username'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: theme.textTheme.bodyText1.color),
                                ),
                                Text(diffDate(DateTime.fromMillisecondsSinceEpoch(commentData['timestamp'] * 1000)),
                                  style: TextStyle(color: theme.hintColor),
                                )
                              ]
                            )
                          ],
                        ),

                        if (visibleDelButton) (
                          Positioned(
                            width: 20,
                            height: 20,
                            top: 0,
                            right: 0,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: delComment,
                              child: Icon(Icons.clear,
                                color: theme.disabledColor,
                                size: 20,
                              ),
                            ),
                          )
                        )
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Column(
                        children: [
                          // 评论内容
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 10),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: theme.textTheme.bodyText1.color),
                                children: [
                                  if (commentData.containsKey('target')) (
                                    TextSpan(
                                      children: [
                                        TextSpan(text: '${Lang.reply} '),
                                        WidgetSpan(
                                          child: TouchableOpacity(
                                            onPressed: () => onTargetUserNamePressed(commentData['target']['id']),
                                            child: Text(commentData['target']['username'] + ' ',
                                              style: TextStyle(
                                                color: theme.accentColor,
                                                fontSize: 14
                                              )
                                            ),
                                          )
                                        )
                                      ]
                                    )
                                  ),

                                  TextSpan(text: trimHtml(commentData['text']))
                                ]
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(right: 25, top: 10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    TouchableOpacity(
                                      onPressed: toggleLike,
                                      child: Selector<CommentProviderModel, _ProviderSelectedLikeData>(
                                        selector: (_, provider) {
                                          final foundData = provider.findByCommentId(pageId, commentData['id'], isPopular);
                                          if (foundData == null) return _ProviderSelectedLikeData(0, false);
                                          return _ProviderSelectedLikeData(foundData['like'], foundData['myatt'] == 1);
                                        },
                                        shouldRebuild: (prev, next) => !prev.equal(next),
                                        builder: (_, likeData, __) => Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 1),
                                              child: [
                                                if (likeData.likeNumber == 0) Icon(AntDesign.like2,
                                                  color: theme.disabledColor,
                                                  size: 17,
                                                ),
                                                if (likeData.likeNumber > 0 && !likeData.liked) Icon(AntDesign.like2,
                                                  color: theme.accentColor,
                                                  size: 17,
                                                ),
                                                if (likeData.liked) Icon(AntDesign.like1,
                                                  color: theme.accentColor,
                                                  size: 17,
                                                )
                                              ][0],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5, top: 2.5),
                                              child: Text(likeData.likeNumber.toString(),
                                                style: TextStyle(
                                                  color: likeData.likeNumber > 0 ? theme.accentColor : theme.disabledColor,
                                                  fontSize: 13
                                                ),
                                              ),
                                            )
                                          ]
                                        ),
                                      )
                                    ),

                                    if (visibleRpleyButton) Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: TouchableOpacity(
                                        onPressed: replyComment,
                                        child: Row(
                                          children: [
                                            Icon(MaterialCommunityIcons.reply,
                                              color: theme.accentColor,
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5, top: 1),
                                              child: Text('${Lang.reply}',
                                                style: TextStyle(
                                                  color: theme.accentColor,
                                                  fontSize: 13
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                  ],
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: CupertinoButton(
                                    minSize: 0,
                                    padding: EdgeInsets.zero,
                                    onPressed: report,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(Icons.assistant_photo,
                                            color: theme.dividerColor,
                                            size: 19,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5, top: 1),
                                          child: Text(Lang.report,
                                            style: TextStyle(
                                              color: theme.dividerColor,
                                              fontSize: 13
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          // 回复
                          if (visibleReply && commentData.containsKey('children') && commentData['children'].length != 0) (
                            NightSelector(
                              builder: (isNight) => (
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 10, right: 25, bottom: 5),
                                  padding: EdgeInsets.all(10),
                                  color: isNight ? theme.backgroundColor : Color(0xffededed),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...replyList.take(3).cast<Map>().map((item) =>
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 2),
                                          child: RichText(
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: theme.textTheme.bodyText1.color,
                                                fontSize: 13,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: item['username'],
                                                  style: TextStyle(color: theme.accentColor)
                                                ),
                                                if (item.containsKey('target')) TextSpan(text: ' ${Lang.reply} '),
                                                if (item.containsKey('target')) TextSpan(
                                                  text: item['target']['username'],
                                                  style: TextStyle(color: theme.accentColor)
                                                ),
                                                TextSpan(text: '：'),
                                                TextSpan(text: trimHtml(item['text']))
                                              ]
                                            ),
                                          ),
                                        )
                                      ).toList(),

                                      CupertinoButton(
                                        minSize: 0,
                                        padding: EdgeInsets.only(top: 3),
                                        onPressed: () => OneContext().pushNamed('/comment/reply', arguments: CommentReplyPageRouteArgs(
                                          pageId: pageId,
                                          commentId: commentData['id']
                                        )),
                                        child: Text('${Lang.replyTotal(replyList.length)} >',
                                          style: TextStyle(
                                            color: theme.accentColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                            )
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderSelectedLikeData {
  final int likeNumber;
  final bool liked;
  
  _ProviderSelectedLikeData(this.likeNumber, this.liked);

  bool equal(_ProviderSelectedLikeData likeData) => likeData.likeNumber == likeNumber && likeData.liked == liked;
}