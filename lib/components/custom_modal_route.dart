import 'package:flutter/material.dart';

class CustomModalRoute extends ModalRoute<void> {
  final Widget child;
  final bool isAndroidBackEnable;
  final Future<bool> Function() onWillPop;
  
  final transitionDuration = Duration(milliseconds: 300);
  final opaque = false;
  final barrierLabel = null;
  final barrierColor;
  final maintainState;
  final bool barrierDismissible;

  CustomModalRoute({
    @required this.child,
    this.isAndroidBackEnable = true,
    this.barrierDismissible = true,
    this.maintainState = false,
    this.onWillPop,
    
    Color barrierColor,
  }) : 
    this.barrierColor = barrierColor ?? Colors.black.withOpacity(0.5),
    super();
    
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: modalContent(context),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  Widget modalContent(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: child,
    ); 
  }
}