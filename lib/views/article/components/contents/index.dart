import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/utils/status_bar_height.dart';
import 'package:one_context/one_context.dart';

Widget articlePageContents(List contentsData, Function(String sectionName) onSectionPressed) {
  final containerWidth = MediaQuery.of(OneContext().context).size.width * 0.55;
  
  // String unwiki(String title) {
  //   return title
  //     .replaceAll(RegExp(r'<.+?>'), '')
  //     .replaceAllMapped(RegExp(r'-\{(.+?)\}-'), (match) => match[1])
  //     .replaceAllMapped(RegExp(r'&#(\d+?);'), (match) => String.fromCharCode(int.parse(match[1])));
  // }

  // final Iterable<dynamic> finalContentData = (contentsData ?? [])
  //   .where((item) => int.parse(item['level']) < 5 && item['level'] != '1')
  //   .map((item) => { 
  //     'level': double.parse(item['level']),
  //     'line': unwiki(item['line']) 
  //   });
    
  return SizedBox(
    width: containerWidth,
    child: Drawer(
      child: Column(
        children: [
          Container(
            height: kToolbarHeight + statusBarHeight,
            padding: EdgeInsets.only(
              top: statusBarHeight,
              left: 10
            ),
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('目录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    splashRadius: 20,
                    icon: Icon(Icons.chevron_right),
                    iconSize: 34,
                    color: Colors.white,
                    onPressed: () => OneContext().pop(),
                  )
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (contentsData ?? []).map((item) =>
                    InkWell(
                      onTap: () => onSectionPressed(item['id']),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: (item['level'] - 2).toDouble() * 10),
                        child: Text((item['level'] >= 3 ? '- ' : '') + item['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: item['level'] < 3 ? 16 : 14,
                            color: item['level'] < 3 ? Color(0xff666666) : Color(0xffababab)
                          ),
                        ),
                      ),
                    )
                  ).toList(),
                ),
              )
            )
          )
        ],
      ),
    ),
  );
}