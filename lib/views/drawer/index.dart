import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                        image: AssetImage('assets/images/akari.jpg'),
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
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                splashRadius: 20,
                icon: Icon(Icons.notifications),
                color: Colors.white,
                onPressed: () => OneContext().pushNamed('/notifications')
              ),
            )
          ),
        ],
      ),
    ),
  );

  Widget listItem(IconData icon, String text, onPressed) {
    return InkWell(
      splashColor: Colors.green[200],
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.green),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(text,
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: 17
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  final listWidget = SingleChildScrollView(
    child: Column(
      children: [
        listItem(Icons.forum, '讨论版', () {})
      ],
    )
  );

  final footerWidget = SizedBox(
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InkWell(
            splashColor: Color(0xffeeeeee),
            onTap: () => OneContext().pushNamed('/settings'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: 22, color: Color(0xff666666)),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('设置', style: TextStyle(color: Color(0xff666666))),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 1,
          alignment: Alignment.center,
          child: Container(
            color: Color(0xffcccccc),
            height: 40 * 0.6
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () => SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'),
            splashColor: Color(0xffeeeeee),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.subdirectory_arrow_left, size: 22, color: Color(0xff666666)),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('退出应用', style: TextStyle(color: Color(0xff666666))),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );

  return _drawerInstance = SizedBox(
    width: width,
    child: Drawer(
      child: Column(
        children: [
          headerWidget,
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/drawer_bg.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topLeft,
                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop)
                )
              ),
              child: Column(
                children: [
                  Expanded(
                    child: listWidget,
                  ),
                  footerWidget,
                ],
              ),
            )
          )
        ],
      )
    ),
  );
}