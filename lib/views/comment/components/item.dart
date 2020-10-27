import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/constants.dart';
import 'package:moegirl_viewer/utils/comment_tree.dart';
import 'package:moegirl_viewer/utils/diff_date.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';

class CommentPageItem extends StatelessWidget {
  final Map commentData;
  final int pageId;
  final String rootCommentId;
  final bool isReply;
  final bool visibleReply;
  final bool visibleRpleyButton;
  final bool visibleReplyNumber;
  final bool visibleDelButton;
  final void Function(String commentId) onReplyButtonPressed;
  final void Function(String userName) onTargetUserNamePressed;
  
  const CommentPageItem({
    @required this.commentData,
    @required this.pageId,
    this.rootCommentId,
    this.isReply = false,
    this.visibleReply = false,
    this.visibleDelButton = false,
    this.visibleReplyNumber = false,
    this.visibleRpleyButton = false,
    this.onReplyButtonPressed,
    this.onTargetUserNamePressed,
    Key key
  }) : super(key: key);

  void delComment() {

  }

  void toggleLike() {

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int likeNumber = commentData['like'];
    final bool isLiked = commentData['myatt'] == 1;
    final replyList = commentData.containsKey('children') ? CommentTree.withTargetData(commentData['children'], commentData['id']) : [];

    String formatContent(String text) {
      return text
        .replaceAll(RegExp(r'(<.+?>|<\/.+?>)'), '')
        .replaceAllMapped(RegExp(r'&(.+?);'), (match) => {
          'gt': '>',
          'lt': '<',
          'amp': '&'
        }[match[1]] ?? match[0])
        .trim();
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: Material(
        child: InkWell(
          onTap: () {},
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
                                    TextSpan(text: '回复 '),
                                    TextSpan(
                                      text: commentData['target']['username'],
                                      style: TextStyle(color: theme.accentColor)
                                    )
                                  ]
                                )
                              ),

                              TextSpan(text: formatContent(commentData['text']))
                            ]
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CupertinoButton(
                                  minSize: 0,
                                  padding: EdgeInsets.only(top: 5, bottom: 10),
                                  onPressed: toggleLike,
                                  child: Row(
                                    children: [
                                      if (likeNumber == 0) Icon(AntDesign.like2,
                                        color: theme.disabledColor,
                                        size: 17,
                                      ),
                                      if (likeNumber > 0 && !isLiked) Icon(AntDesign.like2,
                                        color: theme.accentColor,
                                        size: 17,
                                      ),
                                      if (isLiked) Icon(AntDesign.like1,
                                        color: theme.accentColor,
                                        size: 17,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5, top: 2.5),
                                        child: Text(likeNumber.toString(),
                                          style: TextStyle(
                                            color: likeNumber > 0 ? theme.accentColor : theme.disabledColor,
                                            fontSize: 13
                                          ),
                                        ),
                                      )
                                    ]
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: CupertinoButton(
                                    minSize: 0,
                                    padding: EdgeInsets.only(top: 5, bottom: 10),
                                    onPressed: () {},
                                    child: Icon(MaterialCommunityIcons.reply,
                                      color: theme.accentColor,
                                      size: 20,
                                    ),
                                  )
                                )
                              ],
                            ),

                            CupertinoButton(
                              minSize: 0,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Icon(Icons.assistant_photo,
                                color: theme.dividerColor,
                                size: 19,
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
                              margin: EdgeInsets.only(right: 25, bottom: 5),
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
                                            if (item.containsKey('target')) TextSpan(text: ' 回复 '),
                                            if (item.containsKey('target')) TextSpan(
                                              text: item['target']['username'],
                                              style: TextStyle(color: theme.accentColor)
                                            ),
                                            TextSpan(text: '：'),
                                            TextSpan(text: formatContent(item['text']))
                                          ]
                                        ),
                                      ),
                                    )
                                  ).toList(),

                                  CupertinoButton(
                                    minSize: 0,
                                    padding: EdgeInsets.only(top: 3),
                                    child: Text('共${replyList.length}条回复 >',
                                      style: TextStyle(
                                        color: theme.accentColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    onPressed: () {},
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
    );
  }
}