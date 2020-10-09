import 'package:flutter/material.dart';

class SearchPageRouteArgs {
  final String keyword;
  
  SearchPageRouteArgs({
    this.keyword
  });
}

class SearchPage extends StatefulWidget {
  final SearchPageRouteArgs routeArgs;

  SearchPage(this.routeArgs, {Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: Container()
    );
  }
}