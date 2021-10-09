// @dart=2.9

import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  
  const AppBarIcon({
    @required this.icon,
    this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return IconButton(
      icon: Icon(icon),
      color: theme.colorScheme.onPrimary,
      iconSize: 26,
      splashRadius: 22,
      onPressed: onPressed,
    );
  }
}