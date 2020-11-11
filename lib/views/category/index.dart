import 'package:flutter/material.dart';

class CategoryPageRouteArgs {
  
  CategoryPageRouteArgs();
}

class CategoryPage extends StatefulWidget {
  final CategoryPageRouteArgs routeArgs;
  CategoryPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container()
    );
  }
}