// @dart=2.9
import 'package:flutter/material.dart';

class CustomModalRoute extends ModalRoute<void> {
  final Widget child;
  final Future<bool> Function() onWillPop;
  
  final transitionDuration;
  final opaque = false;
  final barrierLabel = null;
  final barrierColor;
  final maintainState;
  final bool barrierDismissible;

  CustomModalRoute({
    @required this.child,
    this.barrierDismissible = true,
    this.maintainState = false,
    this.transitionDuration = const Duration(milliseconds: 100),
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