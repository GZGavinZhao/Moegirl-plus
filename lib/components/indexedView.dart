import 'package:flutter/material.dart';

class IndexedView<T> extends StatelessWidget {
  final T index;
  final Map<T, Widget Function()> builders;
  
  const IndexedView({
    @required this.index,
    @required this.builders,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (builders[index] ?? (() => Container(width: 0, height: 0)))();
  }
}