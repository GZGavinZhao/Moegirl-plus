import 'package:flutter/material.dart';

class EditHistoryPageRouteArgs {
  
  EditHistoryPageRouteArgs();
}

class EditHistoryPage extends StatefulWidget {
  final EditHistoryPageRouteArgs routeArgs;
  EditHistoryPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _EditHistoryPageState createState() => _EditHistoryPageState();
}

class _EditHistoryPageState extends State<EditHistoryPage> {
  
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