// @dart=2.9
import 'package:flutter/material.dart';

class ToastAnimationWrapper extends StatefulWidget {
  final Widget toast;
  final Function(ToastAnimationController) emitController;
  ToastAnimationWrapper({
    Key key,
    this.toast,
    this.emitController
  }) : super(key: key);

  @override
  _ToastAnimationWrapperState createState() => _ToastAnimationWrapperState();
}

class _ToastAnimationWrapperState extends State<ToastAnimationWrapper> with SingleTickerProviderStateMixin {
  Animation<double> translateY;
  Animation<double> scale;
  Animation<double> opacity;
  AnimationController animationController;
  bool animationReady = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    widget.emitController(ToastAnimationController(show, hide));
  }

  Future<void> show() {
    animationController.duration = const Duration(milliseconds: 300);
    
    translateY = Tween(begin: 5.0, end: 0.0)
      .animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.5, curve: Curves.ease)
      ));
    
    scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.ease
    ));

    opacity = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.5, curve: Curves.ease)
      ));

    setState(() => animationReady = true);
    return animationController.forward().orCancel;
  }

  Future<void> hide() {
    animationController.reset();
    animationController.duration = const Duration(milliseconds: 150);
    
    translateY = Tween(begin: 0.0, end: 5.0)
      .chain(CurveTween(curve: Curves.ease))
      .animate(animationController);
    
    scale = Tween(begin: 1.0, end: 0.8)
      .chain(CurveTween(curve: Curves.ease))
      .animate(animationController);

    opacity = Tween(begin: 1.0, end: 0.0)
      .chain(CurveTween(curve: Curves.ease))
      .animate(animationController);

    // 关闭时必须手动触发一次刷新，否则用的还是show的动画
    setState(() => animationReady = true);
    return animationController.forward().orCancel;
  }
  
  @override
  Widget build(BuildContext context) {
    if (!animationReady) return Container(width: 0, height: 0);

    return AnimatedBuilder(
      animation: translateY,
      child: FadeTransition(
        opacity: opacity ?? 0,
        child: ScaleTransition(
          scale: scale,
          child: widget.toast,
        )
      ),
      builder: (context, child) => (
        Transform(
          transform: Matrix4.translationValues(0, translateY.value, 0),
          child: child,
        )
      )
    );
  }
}

class ToastAnimationController {
  final Future Function() show;
  final Future<void> Function() hide;

  ToastAnimationController(this.show, this.hide);
}

class ToastAnimation {
  final AnimationController controller;
  Map<String, Animation> animatedValues;

  ToastAnimation({
    @required this.controller, 
    Map<String, Animation> Function(AnimationController) animatedValuesCreater
  }) {
    animatedValues = animatedValuesCreater(controller);
  }
}