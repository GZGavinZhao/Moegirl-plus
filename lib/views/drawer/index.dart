import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

Widget _drawerInstance;

Widget globalDrawer() {
  // if (_drawerInstance != null) return _drawerInstance;
  final width = MediaQuery.of(OneContext().context).size.width * 0.6;
  final statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
  const double avatarSize = 75;

  final headerWidget = Container(
    alignment: Alignment.center,
    color: Colors.green,
    height: 150 + statusBarHeight,
    padding: EdgeInsets.only(top: statusBarHeight),
    child: SizedBox.expand(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoButton(
                  onPressed: () => OneContext().pushNamed('/login'),
                  padding: EdgeInsets.all(0),
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(avatarSize / 2)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/akari.jpg')
                      )
                    ),
                  ),
                ),

                CupertinoButton(
                  onPressed: () => OneContext().pushNamed('/login'),
                  padding: EdgeInsets.all(0),
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('登录/加入萌娘百科',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ),
                )
              ],
            )
          ),

          Positioned(
            right: 10,
            child: IconButton(
              icon: Icon(Icons.notifications),
              color: Colors.white,
              onPressed: () => OneContext().pushNamed('/notifications')
            )
          )
        ],
      ),
    ),
  );

  Widget listItem(IconData icon, String text, onPressed) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 10, vertical: 15)
        )
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.green),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(text,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 18
              ),
            ),
          )
        ],
      ),
    );
  }

  final listWidget = Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/drawer_bg.png'),
        alignment: Alignment.topLeft,
        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop)
      )
    ),
    child: SingleChildScrollView(
      child: Column(
        children: [
          listItem(Icons.forum, '讨论版', () {})
        ],
      )
    ),
  );

  // final footerWidget = SizedBox(
  //   child: ,
  // );

  return _drawerInstance = SizedBox(
    width: width,
    child: Drawer(
      child: Column(
        children: [
          headerWidget,
          Expanded(
            child: listWidget,
          )
        ],
      )
    ),
  );
}

class OneConext {
}