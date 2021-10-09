import 'package:flutter/material.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/themes.dart';

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
      duration: Duration(milliseconds: 700),
      vsync: this
    );

    final theme = themes[settingsProvider.theme];
    backgroundColor = ColorTween(begin: theme.colorScheme.secondary.withOpacity(0.5), end: null).animate(controller);
    controller.value = controller.upperBound;
    backgroundColor.addListener(() => setState(() {}));

    if (widget.emitController != null) {
      widget.emitController(CommentPageItemAnimationController(show));
    }
  }

  Future<void> show() async {
    controller.reset();
    return controller.forward().orCancel;
  } 

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Container(color: backgroundColor.value, alignment: Alignment.center),
          ),
        )
      ],  
    );
  }
}

class CommentPageItemAnimationController {
  final Future<void> Function() show;

  CommentPageItemAnimationController(this.show);
}