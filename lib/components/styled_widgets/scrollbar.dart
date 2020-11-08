import 'package:flutter/material.dart';

class StyledScrollbar extends StatelessWidget {
  final Widget child;
  const StyledScrollbar({
    this.child,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 5,
      child: child,
    );
  }
}