import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/parse_edit_summary.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/compare/index.dart';
import 'package:moegirl_plus/views/edit_history/index.dart';
import 'package:one_context/one_context.dart';

class ContributionItem extends StatelessWidget {
  final String pageName;
  final int revId;
  final int prevRevId;
  final String timestamp;
  final String comment;
  final int diffSize;
  
  const ContributionItem({
    @required this.pageName,
    @required this.revId,
    @required this.prevRevId,
    @required this.timestamp,
    @required this.comment,
    @required this.diffSize,
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
            padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10, bottom: 8),
            child: Column(
              children: [
                // 头部
                Row(
                  children: [
                    Text((diffSize > 0 ? '+' : '') + diffSize.toString(),
                      style: TextStyle(
                        color: diffSize >= 0 ? Colors.green : Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(pageName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.1
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                // 摘要
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 8, left: 10, right: 25),
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
                            text: Lang.noSummaryOnCurrentEdit
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
                           TouchableOpacity(
                            disabled: prevRevId == 0,
                            onPressed: () => OneContext().pushNamed('/compare', arguments: ComparePageRouteArgs(
                              toRevId: revId,
                              formRevId: prevRevId,
                              pageName: pageName,
                            )),
                            child: Text(Lang.diff, 
                              style: TextStyle(
                                color: prevRevId != 0 ? theme.colorScheme.secondary : theme.disabledColor,
                                fontSize: 13,
                              )
                            ),
                          ),

                          Text(' | ', style: TextStyle(color: theme.disabledColor)),

                          TouchableOpacity(
                            onPressed: () => OneContext().pushNamed('editHistory', arguments: EditHistoryPageRouteArgs(pageName: pageName)),
                            child: Text(Lang.history, 
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 13
                              )
                            ),
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