// @dart=2.9
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class AppBarBackButton extends StatelessWidget {
  final Color color;
  final Future<bool> Function() willPop;
  
  const AppBarBackButton({
    this.color,
    this.willPop,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: color ?? theme.colorScheme.onPrimary,
      iconSize: 26,
      splashRadius: 20,
      onPressed: () async {
        if (willPop != null && await willPop() == false) return;
        OneContext().pop();
      },
    );
  }
}