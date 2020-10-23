import 'package:flutter/material.dart';

class ArticlePageCommentButtonRippleAnimationLayer extends StatefulWidget {
  final void Function(ArticlePageCommentButtonRippleAnimationController) emitController;
  ArticlePageCommentButtonRippleAnimationLayer({
    this.emitController,
    Key key
  }) : super(key: key);

  @override
  _ArticlePageCommentButtonRippleAnimationLayerState createState() => _ArticlePageCommentButtonRippleAnimationLayerState();
}

class _ArticlePageCommentButtonRippleAnimationLayerState extends State<ArticlePageCommentButtonRippleAnimationLayer> with SingleTickerProviderStateMixin {  
  Animation<double> opacity;
  Animation<double> scale;
  AnimationController controller; 

  @override
  void initState() { 
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this
    );

    opacity = Tween(begin: 1.0, end: 0.0).animate(controller);
    scale = Tween(begin: 1.0, end: 2.5).animate(controller);
    widget.emitController(ArticlePageCommentButtonRippleAnimationController(show));
  }
  
  Future<void> show() async {
    await controller.forward().orCancel;
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Positioned(
      top: 0,
      left: 0,
      child: FadeTransition(
        opacity: opacity,
        child: ScaleTransition(
          scale: scale,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30))
            )
          ),
        ),
      )
    );
  }
}

class ArticlePageCommentButtonRippleAnimationController {
  final Future<void> Function() show;
  ArticlePageCommentButtonRippleAnimationController(this.show);
}