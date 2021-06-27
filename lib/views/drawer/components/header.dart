import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/badge.dart';
import 'package:moegirl_plus/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/utils/status_bar_height.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

const double avatarSize = 75;

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({Key key}) : super(key: key);

  void avatarOrUserNameWasClicked() {
    OneContext().pop();
    if (accountProvider.isLoggedIn) {
      OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
        pageName: 'User:' + accountProvider.userName
      ));
    } else {
      OneContext().pushNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoggedInSelector(
      builder: (isLoggedIn) => (
        Container(
          alignment: Alignment.center,
          color: theme.primaryColor,
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
                            color: Colors.white,
                            border: Border.all(
                              color: theme.colorScheme.onPrimary,
                              width: 3
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(avatarSize / 2)),
                            image: DecorationImage(
                              image: isLoggedIn ? 
                                NetworkImage(avatarUrl + accountProvider.userName) :
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
                          child: Text(isLoggedIn ? Lang.welcomeUser(accountProvider.userName) : Lang.loginOrJoinMoegirl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 16
                            ),
                          )
                        ),
                      )
                    ],
                  )
                ),

                if (isLoggedIn) (
                  Positioned(
                    width: 50,
                    height: 50,
                    right: 10,
                    child: Material(
                      color: Colors.transparent,
                      child: Selector<AccountProviderModel, int>(
                        selector: (_, provider) => provider.waitingNotificationTotal,
                        builder: (_, waitingNotificationTotal, __) => (
                          Stack(
                            children: [
                              IconButton(
                                splashRadius: 20,
                                icon: Icon(Icons.notifications),
                                color: theme.colorScheme.onPrimary,
                                onPressed: () {
                                  OneContext().pop();
                                  OneContext().pushNamed('/notification');
                                }
                              ),

                              if (waitingNotificationTotal > 0) (
                                Positioned(
                                  top: 9,
                                  left: 26,
                                  child: Badge(
                                    text: waitingNotificationTotal.toString()
                                  )
                                )
                              )
                            ],
                          )
                        ),
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