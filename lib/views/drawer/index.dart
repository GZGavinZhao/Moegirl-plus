import 'package:flutter/material.dart';

Drawer _drawerInstance;

Drawer globalDrawer() {
  if (_drawerInstance != null) return _drawerInstance;
  return _drawerInstance = Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Drawer Header',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        )
      ],
    ),
  );
}