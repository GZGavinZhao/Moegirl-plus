// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TouchableOpacity extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final void Function() onPressed;
  
  const TouchableOpacity({
    this.child,
    this.disabled = false,
    this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed: disabled ? null : onPressed,
      child: child,
    );
  }
}