
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DrawerHeader;
import 'package:moegirl_plus/views/drawer/components/body.dart';
import 'package:moegirl_plus/views/drawer/components/header.dart';
import 'package:moegirl_plus/views/drawer/components/scaffold.dart';

import 'components/footer.dart';

class GlobalDrawer extends StatelessWidget {
  const GlobalDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width * 0.6;
    
    return DrawerScaffold(
      width: containerWidth,
      header: DrawerHeader(), 
      body: DrawerBody(), 
      footer: DrawerFooter()
    );
  }
}