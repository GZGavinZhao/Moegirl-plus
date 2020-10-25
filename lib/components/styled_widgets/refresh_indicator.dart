import 'package:flutter/material.dart';

class StyledRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  
  const StyledRefreshIndicator({
    @required this.child,
    @required this.onRefresh,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return RefreshIndicator(
      strokeWidth: 2.5,
      displacement: 25,
      onRefresh: onRefresh,
      child: child,
    );
  }
}