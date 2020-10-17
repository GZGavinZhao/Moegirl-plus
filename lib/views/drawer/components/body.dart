import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moegirl_viewer/mobx/index.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({Key key}) : super(key: key);

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

  void showOperationHelp() {

  }

  @override
  Widget build(BuildContext context) {
    return Observer(
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
  }
}