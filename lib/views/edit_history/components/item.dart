import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/touchable_opacity.dart';
import 'package:moegirl_viewer/constants.dart';
import 'package:moegirl_viewer/utils/parse_edit_summary.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/compare/index.dart';
import 'package:one_context/one_context.dart';

class EditHistoryItem extends StatelessWidget {
  final String pageName;
  final int revId;
  final int prevRevId;
  final String userName;
  final String timestamp;
  final String comment;
  final int diffSize;
  final bool visibleCurrentCompareButton;
  final bool visiblePrevCompareButton;
  
  const EditHistoryItem({
    @required this.pageName,
    @required this.revId,
    @required this.prevRevId,
    @required this.userName,
    @required this.timestamp,
    @required this.comment,
    @required this.diffSize,
    @required this.visibleCurrentCompareButton,
    @required this.visiblePrevCompareButton,
    Key key
  }) : super(key: key);

  void gotoArticle(String pageName) {
    OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: pageName));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editSummary = parseEditSummary(comment);

    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          onTap: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: pageName, revId: revId)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                // 头部
                Row(
                  children: [
                    diffSize != null ? 
                      Text((diffSize > 0 ? '+' : '') + diffSize.toString(),
                        style: TextStyle(
                          color: diffSize >= 0 ? Colors.green : Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1
                        ),
                      )
                    :
                      Text('?', 
                        style: TextStyle(
                          color: theme.disabledColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ))
                    ,
                    
                    TouchableOpacity(
                      onPressed: () => gotoArticle('User:' + userName),
                      child: Container(
                        width: 30,       
                        height: 30,
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: NetworkImage(avatarUrl + userName)
                          )
                        ),
                      ),
                    ),

                    Flexible(
                      flex: -1,
                      child: TouchableOpacity(
                        onPressed: () => gotoArticle('User:' + userName),
                        child: Text(userName,
                          style: TextStyle(
                            color: theme.hintColor,
                            fontSize: 14
                          ),
                        ),
                      )
                    ),

                    TouchableOpacity(
                      onPressed: () => gotoArticle('User_talk:' + userName),
                      child: Text('（讨论）',
                        style: TextStyle(
                          color: theme.accentColor,
                          fontSize: 14,
                          height: 1
                        ),
                      ),
                    )
                  ],
                ),

                // 摘要
                Container(
                  margin: EdgeInsets.only(top: 5, left: 10, right: 25),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: theme.textTheme.bodyText1.color),
                      children: [
                        if (editSummary.section != null) (
                          TextSpan(
                            style: TextStyle(
                              color: theme.hintColor,
                              fontStyle: FontStyle.italic,
                            ),
                            text: '→' + editSummary.section + '  ',
                          )
                        ),
                        editSummary.body != null ?
                          TextSpan(text: editSummary.body)
                        :
                          TextSpan(
                            style: TextStyle(color: theme.disabledColor),
                            text: '该编辑未填写摘要'
                          )
                        ,
                      ]
                    ),
                  ),
                ),

                // 底部
                Padding(
                  padding: EdgeInsets.only(top: 5),
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
                              child: Text('当前', 
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
                                formRevId: prevRevId,
                                pageName: pageName,
                              )),
                              child: Text('之前', 
                                style: TextStyle(
                                  color: theme.accentColor,
                                  fontSize: 13
                                )
                              ),
                            )
                          )
                        ],
                      ),

                      Text(formatDate(DateTime.parse(timestamp).add(Duration(hours: 8)), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]),
                        style: TextStyle(color: theme.hintColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}