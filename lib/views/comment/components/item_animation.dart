import 'package:flutter/material.dart';

class CommentPageItemAnimation extends StatefulWidget {
  final void Function(CommentPageItemAnimationController) emitController;
  final Widget child;
  
  CommentPageItemAnimation({
    @required this.emitController,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  _CommentPageItemAnimationState createState() => _CommentPageItemAnimationState();
}

class _CommentPageItemAnimationState extends 
State<CommentPageItemAnimation> with SingleTickerProviderStateMixin {
  Animation<Color> backgroundColor;
  AnimationController controller;

  @override
  void initState() { 
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );

    final theme = Theme.of(context);
    backgroundColor = Tween(begin: Colors.transparent, end: theme.accentColor).animate(controller);
    backgroundColor.addListener(() => setState(() {}));

    widget.emitController(CommentPageItemAnimationController(show));
  }

  Future<void> show() async {
    return controller.forward().orCancel;
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor.value,
      child: widget,
    );
  }
}

class CommentPageItemAnimationController {
  final Future<void> Function() show;

  CommentPageItemAnimationController(this.show);
}