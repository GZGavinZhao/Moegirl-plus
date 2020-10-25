import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/utils/status_bar_height.dart';
import 'package:one_context/one_context.dart';

class ArticlePageContents extends StatelessWidget {
  final List contentsData;
  final void Function(String sectionName) onSectionPressed;
  
  const ArticlePageContents({
    @required this.contentsData,
    @required this.onSectionPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width * 0.55;
    final theme = Theme.of(context);
    
    return SizedBox(
      width: containerWidth,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: kToolbarHeight + statusBarHeight,
              padding: EdgeInsets.only(
                top: statusBarHeight,
                left: 10
              ),
              color: theme.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('目录',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 20
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      splashRadius: 20,
                      icon: Icon(Icons.chevron_right),
                      iconSize: 34,
                      color: theme.colorScheme.onPrimary,
                      onPressed: () => OneContext().pop(),
                    )
                  )
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: theme.backgroundColor,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (contentsData ?? []).map((item) =>
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: theme.accentColor.withOpacity(0.2),
                            splashColor: theme.accentColor.withOpacity(0.2),
                            onTap: () => onSectionPressed(item['id']),
                            child: Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: (item['level'] - 2).toDouble() * 10),
                              child: Text((item['level'] >= 3 ? '- ' : '') + item['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: item['level'] < 3 ? 16 : 14,
                                  color: item['level'] < 3 ? theme.accentColor : theme.disabledColor
                                ),
                              ),
                            ),
                          ),
                        )
                      ).toList(),
                    ),
                  )
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}