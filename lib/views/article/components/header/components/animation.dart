// @dart=2.9

import 'package:flutter/material.dart';

class ArticlePageHeaderAnimation extends StatefulWidget {
  final Widget Function(Widget Function(Widget) faded) fadedChildBuilder;
  final void Function(ArticlePageHeaderAnimationController) emitController;
  
  
  ArticlePageHeaderAnimation({
    @required this.fadedChildBuilder,
    @required this.emitController,
    Key key
  }) : super(key: key);

  @override
  _ArticlePageHeaderAnimationState createState() => _ArticlePageHeaderAnimationState();
}

class _ArticlePageHeaderAnimationState extends State<ArticlePageHeaderAnimation> with SingleTickerProviderStateMixin {
  Animation<double> opacity;
  Animation<double> translateY;
  AnimationController controller;
  bool isShowing = true;
  
  @override
  void initState() { 
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this
    );
    opacity = Tween(begin: 1.0, end: 0.0).animate(controller);
    translateY = Tween(begin: 0.0, end: -kToolbarHeight).animate(controller);
    translateY.addListener(() => setState(() {}));

    widget.emitController(ArticlePageHeaderAnimationController(show, hide));
  }

  void show() {
    if (isShowing) return;
    isShowing = true;
    controller.reverse();
  }

  void hide() {
    if (!isShowing) return;
    isShowing = false;
    controller..stop()..forward();
  }

  @override
  Widget build(BuildContext context) {
    faded(Widget child) => FadeTransition(opacity: opacity, child: child);
    
    return Container(
      transform: Matrix4.translationValues(0, translateY.value, 0),
      child: widget.fadedChildBuilder(faded)
    );
  }
}

class ArticlePageHeaderAnimationController {
  final void Function() show;
  final void Function() hide;

  ArticlePageHeaderAnimationController(this.show, this.hide);
}