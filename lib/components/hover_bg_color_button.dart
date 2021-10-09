// @dart=2.9
import 'package:flutter/material.dart';

class HoverBgColorButton extends StatefulWidget {
  final Color backgroundColor;
  final void Function() onPressed;
  final Widget child;
  
  HoverBgColorButton({
    this.backgroundColor,
    @required this.onPressed,
    @required this.child,
    Key key
  }) : super(key: key);

  @override
  _HoverBgColorButtonState createState() => _HoverBgColorButtonState();
}

class _HoverBgColorButtonState extends State<HoverBgColorButton> {
  bool isPressing = false;
  Future allowHideBackgroundFuture; // 等待一小段时间，防止用户刚抬起手背景就消失导致看不见hover效果

  void showBackground() {
    setState(() => isPressing = true);
    allowHideBackgroundFuture = Future.delayed(Duration(milliseconds: 120));
  }

  void hideBackground() async {
    await allowHideBackgroundFuture;
    setState(() => isPressing = false);
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hoverColor = widget.backgroundColor ?? theme.highlightColor;
    
    return GestureDetector(
      onTapDown: (_) => showBackground(),
      onTapUp: (_) => hideBackground(),
      onTapCancel: () => hideBackground(),
      onTap: widget.onPressed,
      child: Container(
        color: isPressing ? hoverColor : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}