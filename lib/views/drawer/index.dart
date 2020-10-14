import 'dart:ui';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moegirl_viewer/mobx/index.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';

const avatar_url = 'https://commons.moegirl.org.cn/extensions/Avatar/avatar.php?user=';

Widget _drawerInstance;

Widget globalDrawer() {
  // if (_drawerInstance != null) return _drawerInstance;
  final width = MediaQuery.of(OneContext().context).size.width * 0.6;
  final statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
  const double avatarSize = 75;

  Function beforeCloseDrawer(Function fn) { 
    return () {
      OneContext().pop();
      fn(); 
    };
  }

  void avatarOrUserNameWasClicked() {
    if (accountStore.isLoggedIn) {
      OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
        pageName: 'User:' + accountStore.userName
      ));
    } else {
      OneContext().pushNamed('/login');
    }
  }

  void showOperationHelp() {

  }

  final headerWidget = Observer(
    builder: (context) => (
      Container(
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
                      onPressed: beforeCloseDrawer(avatarOrUserNameWasClicked),
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
                            image: accountStore.isLoggedIn ? 
                              NetworkImage(avatar_url + accountStore.userName) :
                              AssetImage('assets/images/akari.jpg')
                            ,
                          )
                        ),
                      ),
                    ),

                    CupertinoButton(
                      onPressed: beforeCloseDrawer(avatarOrUserNameWasClicked),
                      padding: EdgeInsets.all(0),
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(accountStore.isLoggedIn ? '欢迎你，${accountStore.userName}' : '登录/加入萌娘百科',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        )
                      ),
                    )
                  ],
                )
              ),

              if (accountStore.isLoggedIn) (
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
                )
              )
            ],
          ),
        ),
      )
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

  final listWidget = Observer(
    builder: (context) => (
      SingleChildScrollView(
        child: Column(
          children: [
            listItem(Icons.forum, '讨论版', () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
              pageName: '萌娘百科 talk:讨论版'
            ))),
            listItem(Icons.format_indent_decrease, '最近更改', () => OneContext().pushNamed('/recentChanges')),
            if (accountStore.isLoggedIn) listItem(CommunityMaterialIcons.eye, '监视列表', () => OneContext().pushNamed('/watchList')),
            listItem(Icons.history, '浏览历史', () => OneContext().pushNamed('/history')),
            listItem(Icons.touch_app, '操作提示', showOperationHelp),
          ],
        )
      )
    ),
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