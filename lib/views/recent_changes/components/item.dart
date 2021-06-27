import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/parse_edit_summary.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/compare/index.dart';
import 'package:moegirl_plus/views/contribution/index.dart';
import 'package:moegirl_plus/views/edit_history/index.dart';
import 'package:moegirl_plus/views/recent_changes/components/detail_item.dart';
import 'package:one_context/one_context.dart';

class RecentChangesItem extends StatefulWidget {
  /// new | edit | log
  final String type;
  final String pageName;
  final String comment;
  /// { name: string, total: number }
  final List users;
  final int newLength;
  final int oldLength;
  final int revId;
  final int oldRevId;
  final String dateISO;
  final List editDetails;
  final bool pageWatched;

  RecentChangesItem({
    @required this.type,
    @required this.pageName,
    @required this.comment,
    @required this.users,
    @required this.newLength,
    @required this.oldLength,
    @required this.revId,
    @required this.oldRevId,
    @required this.dateISO,
    @required this.editDetails,
    @required this.pageWatched,
    Key key
  }) : super(key: key);

  @override
  _RecentChangesItemState createState() => _RecentChangesItemState();
}

class _RecentChangesItemState extends State<RecentChangesItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool visibleEditDetails = false;
  
  void gotoArticle(String pageName) {
    OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: pageName));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final totalNumberOfEdit = widget.users.fold<int>(0, (result, item) => result + item['total']);
    final isSingleEdit = totalNumberOfEdit == 1;
    final diffSize = widget.newLength - widget.oldLength;
    final editSummary = parseEditSummary(widget.comment);
    
    final titleWidget = Container(
      height: 25,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 25),
      child: Row(
        children: [
          if (widget.type != 'log') (
            Text((diffSize > 0 ? '+' : '') + diffSize.toString(),
              style: TextStyle(
                color: diffSize >= 0 ? Colors.green : Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1
              ),
            )
          ),

          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text({ 'new': '(${Lang.new_})', 'edit': '', 'log': '(${Lang.log})' }[widget.type],
              style: TextStyle(
                color: {
                  'new': Colors.green,
                  'edit': Colors.green,
                  'log': Colors.grey
                }[widget.type],
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1
              ),
            ),
          ),
          
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              child: Container(
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: widget.pageWatched ? Border(bottom: BorderSide(color: theme.accentColor, width: 5)) : null
                  ),
                  child: TouchableOpacity(
                    onPressed: () => gotoArticle(widget.pageName),
                    child: Text(widget.pageName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.textTheme.bodyText1.color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.1
                      ),
                    ),
                  ),
                )
              ),
            ),
          )
        ]
      )
    );

    final summaryWidget = Container(
      margin: EdgeInsets.only(top: 5, left: 10, right: 25, bottom: 5),
      alignment: Alignment.center,
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
    );

    final usersBarWidget = () => (
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: NotificationListener<ScrollNotification>(  // 防止向上广播出现横向滚动条
          onNotification: (notification) => true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: widget.users.asMap().map((index, user) =>
                MapEntry(
                  index,
                  Row(
                    children: [
                      TouchableOpacity(
                        onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: 'User:${user['name']}')),
                        child: Container(
                          width: 30,       
                          height: 30,
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage(avatarUrl + user['name'])
                            )
                          ),
                        ),
                      ),
                      TouchableOpacity(
                        onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: 'User:${user['name']}')),
                        child: Text('${user['name']} (×${user['total']})',
                          style: TextStyle(color: theme.hintColor, fontSize: 13),
                        ),
                      ),
                      if (index != widget.users.length - 1) (
                        Text('、',  style: TextStyle(color: theme.hintColor))
                      )
                    ],
                  ),
                )
              ).values.toList(),
            ),
          )
        ),
      )
    );
      
    final footerWidget = Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isSingleEdit ? 
            TouchableOpacity(
              onPressed: () => setState(() => visibleEditDetails = !visibleEditDetails),
              child: Row(
                children: [
                  SizedBox(
                    width: 17.5,
                    height: 17.5,
                    child: Icon(visibleEditDetails ? FontAwesome.caret_down : FontAwesome.caret_right,
                      size: 20,
                      color: theme.accentColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(Lang.toggleRecentChangeDetail(visibleEditDetails, totalNumberOfEdit),
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.accentColor
                      ),
                    ),
                  )
                ],
              ),
            )
          :
            Row(
              children: [
                TouchableOpacity(
                  onPressed: () => gotoArticle('User:' + widget.users[0]['name']),
                    child: Container(
                    width: 30,       
                    height: 30,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(avatarUrl + widget.users[0]['name'])
                      )
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TouchableOpacity(
                      onPressed: () => gotoArticle('User:' + widget.users[0]['name']),
                      child: Text(widget.users[0]['name'],
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.hintColor,
                          height: 1.1
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TouchableOpacity(
                          onPressed: () => gotoArticle('User_talk:' + widget.users[0]['name']),
                          child: Text(Lang.talk,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.accentColor,
                            ),
                          ),
                        ),
                        Text(' | ', style: TextStyle(fontSize: 11, color: theme.hintColor)),
                        TouchableOpacity(
                          onPressed: () => OneContext().pushNamed('/contribution', arguments: ContributionPageRouteArgs(
                          userName: widget.users[0]['name']
                        )),
                          child: Text(Lang.contribution,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.accentColor
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
          ,

          Text(formatDate(DateTime.parse(widget.dateISO).add(Duration(hours: 8)), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]),
            style: TextStyle(color: theme.hintColor),
          )
        ],
      ),
    );
    
    final rightFloatedButton = Column(
      children: [
        if (widget.type == 'edit') (
          TouchableOpacity(
            onPressed: () => OneContext().pushNamed('/compare', arguments: ComparePageRouteArgs(
              formRevId: widget.oldRevId,
              toRevId: widget.revId,
              pageName: widget.pageName,
            )),
            child: Icon(Icons.compare_arrows,
              size: 25,
              color: theme.accentColor,
            ),
          )
        ),
        
        TouchableOpacity(
          onPressed: () => OneContext().pushNamed('/editHistory', arguments: EditHistoryPageRouteArgs(pageName: widget.pageName)),
          child: Icon(Icons.history,
            size: 25,
            color: theme.accentColor
          ),
        )
      ],
    );

    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget,
                    summaryWidget,
                    if (!isSingleEdit) usersBarWidget(),
                    footerWidget,
                    if (widget.editDetails != null && widget.editDetails.length != 0 && visibleEditDetails) (
                      Column(
                        children: widget.editDetails.map((item) =>
                          Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: RecentChangesDetailItem(
                              type: item['type'],
                              comment: item['comment'],
                              userName: item['user'],
                              newLength: item['newlen'],
                              oldLength: item['oldlen'],
                              revId: item['revid'],
                              oldRevId: item['old_revid'],
                              dateISO: item['timestamp'],
                              pageName: widget.pageName,
                              // 详细列表中的第一条(也就是本身)，不显示“当前”按钮
                              visibleCurrentCompareButton: item['type'] == 'edit' && item['revid'] != widget.revId,
                              visiblePrevCompareButton: item['type'] == 'edit',
                            ),
                          )
                        ).toList(),
                      )
                    )
                  ],
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  child: rightFloatedButton,
                )
              ],
            ),
          )
        ),
      )
    );
  }
}