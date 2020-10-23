import 'package:flutter/material.dart';

class SettingsPageRouteArgs {
  
  SettingsPageRouteArgs();
}

class SettingsPage extends StatefulWidget {
  final SettingsPageRouteArgs routeArgs;
  SettingsPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  
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