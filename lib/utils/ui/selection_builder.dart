import 'package:flutter/material.dart';

Widget selectionBuilder({
  @required dynamic key,
  @required Map<int, Widget Function()> views
}) {
  return (views[key] ?? (() => null))();
}