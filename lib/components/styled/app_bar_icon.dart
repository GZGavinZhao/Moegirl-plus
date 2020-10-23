
import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  
  const AppBarIcon({
    this.icon,
    this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 26,
      splashRadius: 22,
      onPressed: onPressed,
    );
  }
}