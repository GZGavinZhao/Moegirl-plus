import 'package:flutter/material.dart';

class StyledRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final GlobalKey<RefreshIndicatorState> bodyKey;
  
  const StyledRefreshIndicator({
    @required this.child,
    @required this.onRefresh,
    this.bodyKey,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return RefreshIndicator(
      key: bodyKey,
      strokeWidth: 2.5,
      displacement: 25,
      onRefresh: onRefresh,
      child: child,
    );
  }
}