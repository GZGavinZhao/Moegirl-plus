import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';
import 'package:package_info/package_info.dart';

final moegirlRendererJsFuture = rootBundle.loadString('assets/app.json');

void showAboutDialog() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final appInfo = jsonDecode(await moegirlRendererJsFuture);
  
  OneContext().showDialog(
    barrierDismissible: true,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('关于'),
        content: SizedBox(
          height: 80,
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/moemoji.png', width: 70, height: 60),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('版本：${packageInfo.version}'),
                      Text('更新日期：${appInfo['date']}'),
                      Row(
                        children: [
                          Text('开发：'),
                          CupertinoButton(
                            minSize: 0,
                            onPressed: () {
                              OneContext().popDialog();
                              OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: 'User:東東君'));
                            },
                            padding: EdgeInsets.zero,
                            child: Text('東東君',
                              style: TextStyle(
                                color: theme.accentColor,
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
            child: Text('关闭'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}