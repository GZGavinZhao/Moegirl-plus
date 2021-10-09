// @dart=2.9
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/contribution/index.dart';
import 'package:one_context/one_context.dart';

class UserTail extends StatelessWidget {
  final String userName;
  final double fontSize;

  const UserTail({
    @required this.userName,
    this.fontSize = 13,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Text(' (', style: TextStyle(color: theme.hintColor, height: 0.7, fontSize: fontSize)),
        TouchableOpacity(
          onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: 'User_talk:$userName')),
          child: Text(Lang.talk,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: fontSize,
              height: 1
            ),
          ),
        ),
        Text(' | ', style: TextStyle(color: theme.disabledColor, height: 0.7, fontSize: fontSize)),
        TouchableOpacity(
          onPressed: () => OneContext().pushNamed('/contribution', arguments: ContributionPageRouteArgs(
            userName: userName
          )),
          child: Text(Lang.contribution,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: fontSize,
              height: 1
            ),
          ),
        ),
        Text(')', style: TextStyle(color: theme.hintColor, height: 0.7, fontSize: fontSize))
      ],
    );
  }
}