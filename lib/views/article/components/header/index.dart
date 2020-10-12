import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:moegirl_viewer/components/app_bar_icon.dart';
import 'package:one_context/one_context.dart';

import 'components/animation.dart';

class ArticlePageHeader extends StatelessWidget {
  final String title;
  final Function(ArticlePageHeaderAnimationController) onControllerCreated;
  const ArticlePageHeader({
    this.title,
    this.onControllerCreated,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArticlePageHeaderAnimation(
      onControllerCreated: onControllerCreated,
      fadedChildBuilder: (faded) {
        return AppBar(
          elevation: 0,
          title: faded(Text(title)),
          leading: Builder(
            builder: (context) => faded(appBarIcon(Icons.arrow_back, () => OneContext().pop()))
          ),
          actions: [
            faded(appBarIcon(Icons.search, () => OneContext().pushNamed('search'))),
            faded(PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (result) { print(result); },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text('haha'),
                )
              ],
            ))
          ],
        );
      }
    );
  }
}