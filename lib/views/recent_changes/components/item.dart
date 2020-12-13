import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:moegirl_viewer/components/touchable_opacity.dart';
import 'package:moegirl_viewer/constants.dart';
import 'package:moegirl_viewer/utils/parse_edit_summary.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/recent_changes/components/detail_item.dart';
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
  final int oldrevId;
  final String dateISO;
  final List editDetails;

  RecentChangesItem({
    @required this.type,
    @required this.pageName,
    @required this.comment,
    @required this.users,
    @required this.newLength,
    @required this.oldLength,
    @required this.revId,
    @required this.oldrevId,
    @required this.dateISO,
    @required this.editDetails,
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
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyText1.color
          ),
          children: [
            if (widget.type != 'log') (
              TextSpan(
                style: TextStyle(
                  color: diffSize >= 0 ? Colors.green : Colors.redAccent
                ),
                text: (diffSize > 0 ? '+' : '') + diffSize.toString()
              )
            ),
            TextSpan(
              style: TextStyle(
                color: {
                  'new': Colors.green,
                  'edit': Colors.green,
                  'log': Colors.grey
                }[widget.type]
              ),
              text: { 'new': '(新)', 'edit': '', 'log': '(日志)' }[widget.type] + ' ',
            ),
            WidgetSpan(
              child: TouchableOpacity(
                onPressed: () => gotoArticle(widget.pageName),
                child: Text(widget.pageName,
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            )
          ]
        ),
      ),
    );

    final summaryWidget = Container(
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
    );

    final usersBarWidget = () => (
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: NotificationListener<ScrollNotification>(  // 防止向上广播出现横向滚动条
          onNotification: (notification) => true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.users.asMap().map((index, user) =>
                MapEntry(
                  index,
                  Row(
                    children: [
                      Container(
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
                      Text('${user['name']} (×${user['total']})',
                        style: TextStyle(color: theme.hintColor),
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
                    // ignore: unnecessary_brace_in_string_interps
                    child: Text((visibleEditDetails ? '收起' : '展开') + '详细记录(共${totalNumberOfEdit}次编辑)',
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
                          color: theme.hintColor
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TouchableOpacity(
                          onPressed: () => gotoArticle('User_talk:' + widget.users[0]['name']),
                          child: Text('讨论',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.accentColor
                            ),
                          ),
                        ),
                        Text(' | ', style: TextStyle(fontSize: 11, color: theme.hintColor)),
                        TouchableOpacity(
                          // 跳转贡献页
                          // onPressed: () => gotoArticle('User_talk:' + widget.users[0]['name']),
                          child: Text('贡献',
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

          Text(formatDate(DateTime.parse(widget.dateISO), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]),
            style: TextStyle(color: theme.hintColor),
          )
        ],
      ),
    );
    
    final rightFloatedButton = Column(
      children: [
        TouchableOpacity(
          child: Icon(Icons.compare_arrows,
            size: 25,
            color: theme.accentColor,
          ),
        ),
        TouchableOpacity(
          child: Icon(Icons.history,
            size: 25,
            color: theme.accentColor
          ),
        )
      ],
    );

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 1),
      color: theme.colorScheme.surface,
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
                        oldrevId: item['old_revid'],
                        dateISO: item['timestamp'],
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
    );
  }
}