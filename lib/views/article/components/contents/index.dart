import 'package:flutter/material.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/status_bar_height.dart';
import 'package:one_context/one_context.dart';

class ArticlePageContents extends StatelessWidget {
  final List contentsData;
  final bool notInTopLayer; // 不处于顶层，不附加状态栏高度的padding
  final void Function(String sectionName) onSectionPressed;
  
  const ArticlePageContents({
    @required this.contentsData,
    this.notInTopLayer = false,
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
              height: kToolbarHeight + (notInTopLayer ?  0 : statusBarHeight),
              padding: EdgeInsets.only(
                top: (notInTopLayer ? 0 : statusBarHeight),
                left: 10
              ),
              color: theme.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Lang.contents,
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
                width: containerWidth,
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
                            highlightColor: theme.colorScheme.secondary.withOpacity(0.2),
                            splashColor: theme.colorScheme.secondary.withOpacity(0.2),
                            onTap: () => onSectionPressed(item['id']),
                            child: Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: ((item['level'] - 2 < 0 ? 0 : item['level'] - 2)).toDouble() * 10),
                              child: Text((item['level'] >= 3 ? '- ' : '') + item['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: item['level'] < 3 ? 16 : 14,
                                  color: item['level'] < 3 ? theme.colorScheme.secondary : theme.disabledColor
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