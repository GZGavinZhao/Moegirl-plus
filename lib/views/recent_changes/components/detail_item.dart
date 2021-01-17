import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/parse_edit_summary.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/compare/index.dart';
import 'package:moegirl_plus/views/contribution/index.dart';
import 'package:one_context/one_context.dart';

class RecentChangesDetailItem extends StatelessWidget {
    /// new | edit | log
  final String type;
  final String comment;
  final String userName;
  final int newLength;
  final int oldLength;
  final int revId;
  final int oldRevId;
  final String dateISO;
  final String pageName;
  final bool visibleCurrentCompareButton;  // 是否显示“当前”按钮
  final bool visiblePrevCompareButton;  // 是否显示之前按钮

  RecentChangesDetailItem({
    @required this.type,
    @required this.comment,
    @required this.userName,
    @required this.newLength,
    @required this.oldLength,
    @required this.revId,
    @required this.oldRevId,
    @required this.dateISO,
    @required this.pageName,
    this.visibleCurrentCompareButton = true,
    this.visiblePrevCompareButton = true,
    Key key
  }) : super(key: key);

  void gotoArticle(String pageName) {
    OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: pageName));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diffSize = newLength - oldLength;
    final editSummary = parseEditSummary(comment);
    
    return Container(
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.only(top: 10, left: 3.5),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: diffSize >= 0 ? Colors.green : Colors.redAccent,
            width: 5
          )
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((diffSize > 0 ? '+' : '') + diffSize.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: diffSize >= 0 ? Colors.green : Colors.redAccent
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text({ 'new': '(${l.recentChangesPage_detailItem_new})', 'edit': '', 'log': '(${l.recentChangesPage_detailItem_log})' }[type],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1,
                        color: {
                          'new': Colors.green,
                          'edit': Colors.green,
                          'log': Colors.grey
                        }[type]
                      ),
                    ),
                  )
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TouchableOpacity(
                    onPressed: () => gotoArticle('User:$userName'),
                    child: Container(
                      width: 30,       
                      height: 30,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl + userName)
                        )
                      ),
                    ),
                  ),
                  TouchableOpacity(
                    onPressed: () => gotoArticle('User:$userName'),
                    child: Text(userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 14,
                        height: 1
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(' (', style: TextStyle(color: theme.hintColor, height: 0.7)),
                      TouchableOpacity(
                        onPressed: () => gotoArticle('User_talk:$userName'),
                        child: Text(l.recentChangesPage_detailItem_talk,
                          style: TextStyle(
                            color: theme.accentColor,
                            fontSize: 14,
                            height: 1
                          ),
                        ),
                      ),
                      Text(' | ', style: TextStyle(color: theme.disabledColor, height: 0.7)),
                      TouchableOpacity(
                        onPressed: () => OneContext().pushNamed('/contribution', arguments: ContributionPageRouteArgs(
                          userName: userName
                        )),
                        child: Text(l.recentChangesPage_detailItem_contribution,
                          style: TextStyle(
                            color: theme.accentColor,
                            fontSize: 14,
                            height: 1
                          ),
                        ),
                      ),
                      Text(')', style: TextStyle(color: theme.hintColor, height: 0.7))
                    ],
                  )
                ],
              )
            ],
          ),

          // 编辑摘要
          Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 25),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: theme.textTheme.bodyText1.color
                ),
                children: [
                  if (editSummary.section != null) (
                    TextSpan(
                      text: '→' + editSummary.section + '  ',
                      style: TextStyle(
                        color: theme.hintColor,
                        fontStyle: FontStyle.italic
                      )
                    )
                  ),
                  editSummary.body != null ? 
                    TextSpan(text: editSummary.body)
                  :
                    TextSpan(text: l.recentChangesPage_detailItem_noSummary,
                      style: TextStyle(color: theme.disabledColor)
                    )
                  ,
                ]
              ),
            ),
          ),

          // 尾部
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (visibleCurrentCompareButton) (
                      TouchableOpacity(
                        onPressed: () => OneContext().pushNamed('/compare', arguments: ComparePageRouteArgs(
                          formRevId: revId,
                          pageName: pageName,
                        )),
                        child: Text(l.recentChangesPage_detailItem_current, 
                          style: TextStyle(
                            color: theme.accentColor,
                            fontSize: 13
                          )
                        ),
                      )
                    ),

                    if (visibleCurrentCompareButton && visiblePrevCompareButton) (
                      Text(' | ', style: TextStyle(color: theme.disabledColor))
                    ),

                    if (visiblePrevCompareButton) (
                      TouchableOpacity(
                        onPressed: () => OneContext().pushNamed('/compare', arguments: ComparePageRouteArgs(
                          toRevId: revId,
                          formRevId: oldRevId,
                          pageName: pageName,
                        )),
                        child: Text(l.recentChangesPage_detailItem_last, 
                          style: TextStyle(
                            color: theme.accentColor,
                            fontSize: 13
                          )
                        ),
                      )
                    )
                  ],
                ),

                Text(formatDate(DateTime.parse(dateISO), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]),
                  style: TextStyle(color: theme.hintColor)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}