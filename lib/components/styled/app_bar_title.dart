import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String text;
  const AppBarTitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(text,
      style: TextStyle(color: theme.colorScheme.onPrimary),
    );
  }
}