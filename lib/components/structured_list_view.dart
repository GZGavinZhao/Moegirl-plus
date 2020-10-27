import 'package:flutter/material.dart';

class StructuredListView<T> extends StatelessWidget {
  final List<T> itemDataList;
  final Widget Function(BuildContext, T data) itemBuilder;
  final Widget Function() headerBuilder;
  final Widget Function() footerBuilder;

  final EdgeInsets padding;
  final ScrollController controller;
  
  const StructuredListView({
    @required this.itemDataList,
    @required this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,

    this.padding,
    this.controller,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemDataList.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return headerBuilder != null ? headerBuilder() : Container(width: 0, height: 0);
        if (index == itemDataList.length + 1) return footerBuilder != null ? footerBuilder() : Container(width: 0, height: 0);
        return itemBuilder(context, itemDataList[index - 1]);
      }
    );
  }
}