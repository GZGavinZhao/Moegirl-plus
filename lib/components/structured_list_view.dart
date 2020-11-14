import 'package:flutter/material.dart';

class StructuredListView<T> extends StatelessWidget {
  final List<T> itemDataList;
  final Widget Function(BuildContext, T data, int index) itemBuilder;
  final Widget Function() headerBuilder;
  final Widget Function() footerBuilder;
  final bool reverse;

  // ListView原始参数
  final EdgeInsets padding;
  final ScrollController controller;
  
  const StructuredListView({
    @required this.itemDataList,
    @required this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,

    this.padding,
    this.controller,
    this.reverse = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: AlwaysScrollableScrollPhysics(),
      padding: padding,
      itemCount: itemDataList.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return headerBuilder != null ? headerBuilder() : Container(width: 0, height: 0);
        if (index == itemDataList.length + 1) return footerBuilder != null ? footerBuilder() : Container(width: 0, height: 0);
        final itemIndex = index - 1;
        return itemBuilder(context, (reverse ? itemDataList.reversed.toList() : itemDataList)[itemIndex], itemIndex);
      },
    );
  }
}