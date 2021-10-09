// @dart=2.9
import 'package:flutter/material.dart';
import 'package:moegirl_plus/utils/break_text.dart';

class AppBarTitle extends StatelessWidget {
  final String text;
  const AppBarTitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(breakText(text),
      style: TextStyle(color: theme.colorScheme.onPrimary),
    );
  }
}