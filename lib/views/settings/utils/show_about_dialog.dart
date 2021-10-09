// @dart=2.9

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/get_custom_app_info.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:one_context/one_context.dart';
import 'package:package_info/package_info.dart';

void showAboutDialog(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final appInfo = await getCustomAppInfo();
  
  showDialog(
    context: context,
    barrierDismissible: true,
    useRootNavigator: false,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(Lang.about,
          style: TextStyle(fontSize: 18),
        ),
        content: SizedBox(
          height: 80,
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/${RuntimeConstants.source}/app_icon.png', 
                width: 70, height: 70),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${Lang.version}：${packageInfo.version}'),
                      Text('${Lang.updateDate}：${appInfo.date}'),
                      Row(
                        children: [
                          Text('${Lang.development}：'),
                          TouchableOpacity(
                            onPressed: () {
                              OneContext().pop();
                              OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: 'User:東東君'));
                            },
                            child: Text('東東君',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ),
        actions: [
          TextButton(
            child: Text(Lang.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}