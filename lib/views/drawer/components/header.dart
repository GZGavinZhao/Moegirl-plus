import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moegirl_viewer/mobx/index.dart';
import 'package:moegirl_viewer/utils/status_bar_height.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';

const avatar_url = 'https://commons.moegirl.org.cn/extensions/Avatar/avatar.php?user=';
const double avatarSize = 75;

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({Key key}) : super(key: key);

  void avatarOrUserNameWasClicked() {
    OneContext().pop();
    
    if (accountStore.isLoggedIn) {
      OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
        pageName: 'User:' + accountStore.userName
      ));
    } else {
      OneContext().pushNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
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
                        onPressed: avatarOrUserNameWasClicked,
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
                        onPressed: avatarOrUserNameWasClicked,
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
  }
}