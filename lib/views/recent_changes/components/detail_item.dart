import 'package:flutter/material.dart';
import 'package:moegirl_viewer/constants.dart';
import 'package:moegirl_viewer/utils/parse_edit_symmary.dart';

class RecentChangesDetailItem extends StatelessWidget {
    /// new | edit | log
  final String type;
  final String pageName;
  final String comment;
  final String userName;
  final int newLength;
  final int oldLength;
  final int revId;
  final int oldrevId;
  final String dateISO;

  RecentChangesDetailItem({
    @required this.type,
    @required this.pageName,
    @required this.comment,
    @required this.userName,
    @required this.newLength,
    @required this.oldLength,
    @required this.revId,
    @required this.oldrevId,
    @required this.dateISO,
    Key key
  }) : super(key: key);
  
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
        children: [
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
                    child: Text({ 'new': '(新)', 'edit': '', 'log': '(日志)' }[type],
                      style: TextStyle(
                        fontSize: 16,
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
                  Container(
                    width: 30,       
                    height: 30,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(avatarUrl + userName)
                      )
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}