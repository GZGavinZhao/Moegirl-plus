import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class AppBarBackButton extends StatelessWidget {
  final Color color;
  const AppBarBackButton({
    this.color,
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
      onPressed: () => OneContext().pop(),
    );
  }
}