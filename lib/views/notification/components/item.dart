import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/badge.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/constants.dart';
import 'package:moegirl_viewer/utils/diff_date.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';

class NotificationPageItem extends StatelessWidget {
  final Map notificationData;
  final void Function() onPressed;
  
  const NotificationPageItem({
    @required this.notificationData,
    @required this.onPressed,
    Key key
  }) : super(key: key);

  List<InlineSpan> strongTagToFlutterBoldText(String html) {
    final strongTagRegex = RegExp(r'<(b|strong)>(.+?)<\/(b|strong)>');
    final normalTexts = html.split(strongTagRegex);
    final strongTexts = strongTagRegex
      .allMatches(html)
      .map((item) => item[2])
      .toList();
    
    return normalTexts
      .asMap().map((index, normalText) => 
        MapEntry(index,
          TextSpan(
            children: [
              TextSpan(text: normalText),
              if (index < strongTexts.length) (
                TextSpan(
                  text: strongTexts[index],
                  style: TextStyle(fontWeight: FontWeight.bold)
                )
              )
            ]
          )
        )
      ).values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bodyText = notificationData['*']['body'] != '' ? notificationData['*']['body'] : notificationData['*']['compactHeader'];
    
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5, right: 10),
                  child: CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                      pageName: 'User:' + notificationData['agent']['name']
                    )),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl + notificationData['agent']['name'])
                        ),
                      ),
                      alignment: Alignment.topRight,
                      child: !notificationData.containsKey('read') ? Badge() : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: theme.textTheme.bodyText1.color
                          ),
                          children: strongTagToFlutterBoldText(notificationData['*']['header'])
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(bodyText,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.hintColor
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(diffDate(DateTime.fromMillisecondsSinceEpoch(int.parse(notificationData['timestamp']['unix']) * 1000)),
                          style: TextStyle(
                            color: theme.hintColor
                          ),
                        ),
                      )
                    ]
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}