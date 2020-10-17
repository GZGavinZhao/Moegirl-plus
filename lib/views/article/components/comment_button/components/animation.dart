import 'package:flutter/material.dart';

class ArticlePageCommentButtonAnimation extends StatefulWidget {
  final void Function(ArticlePageCommentButtonAnimationControler) emitController;
  final Widget child;
  
  ArticlePageCommentButtonAnimation({
    this.emitController,
    this.child,
    Key key
  }) : super(key: key);

  @override
  _ArticlePageCommentButtonAnimationState createState() => _ArticlePageCommentButtonAnimationState();
}

class _ArticlePageCommentButtonAnimationState extends State<ArticlePageCommentButtonAnimation> with SingleTickerProviderStateMixin {
  Animation<double> translateX;
  AnimationController controller;
  bool isShowing = false;

  @override
  void initState() { 
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this
    );

    translateX = Tween(begin: 80.0, end: 0.0).animate(controller);
    translateX.addListener(() => setState(() {}));
    widget.emitController(ArticlePageCommentButtonAnimationControler(show, hide));
  }

  Future<void> show() async {
    if (isShowing) return;
    isShowing = true;
    return controller.forward().orCancel;
  }

  Future<void> hide() async {
    if (!isShowing) return;
    isShowing = false; 
    return controller.reverse().orCancel;
  }
  
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(translateX.value, 0, 0),
      child: widget.child
    );
  }
}

class ArticlePageCommentButtonAnimationControler {
  final Future<void> Function() show;
  final Future<void> Function() hide;

  ArticlePageCommentButtonAnimationControler(this.show, this.hide);
}