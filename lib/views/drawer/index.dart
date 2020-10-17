
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DrawerHeader;
import 'package:moegirl_viewer/views/drawer/components/body.dart';
import 'package:moegirl_viewer/views/drawer/components/header.dart';
import 'package:moegirl_viewer/views/drawer/components/scaffold.dart';
import 'package:one_context/one_context.dart';

import 'components/footer.dart';

Widget _drawerInstance;

Widget globalDrawer() {
  // if (_drawerInstance != null) return _drawerInstance;
  final containerWidth = MediaQuery.of(OneContext().context).size.width * 0.6;

  return _drawerInstance = DrawerScaffold(
    width: containerWidth,
    header: DrawerHeader(), 
    body: DrawerBody(), 
    footer: DrawerFooter()
  );
}