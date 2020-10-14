import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:moegirl_viewer/components/app_bar_icon.dart';
import 'package:moegirl_viewer/mobx/index.dart';
import 'package:one_context/one_context.dart';

import 'components/animation.dart';

class ArticlePageHeader extends StatelessWidget {
  final String title;
  final bool isExistsInWatchList;
  final Function(ArticlePageHeaderAnimationController) emitController;
  final Function(ArticlePageHeaderMoreMenuValue) onMoreMenuPressed;
  
  const ArticlePageHeader({
    @required this.title,
    @required this.isExistsInWatchList,
    this.onMoreMenuPressed,
    this.emitController,
    Key key,
  }) : super(key: key);

  void menuButtonWasClicked(String value) {
    if (value == 'refresh') {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return ArticlePageHeaderAnimation(
      emitController: emitController,
      fadedChildBuilder: (faded) => (
        AppBar(
          elevation: 0,
          title: faded(Text(title)),
          leading: Builder(
            builder: (context) => faded(appBarIcon(Icons.arrow_back, () => OneContext().pop()))
          ),
          actions: [
            faded(appBarIcon(Icons.search, () => OneContext().pushNamed('search'))),
            faded(Observer(
              builder: (context) => (
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  onSelected: onMoreMenuPressed,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.refresh,
                      child: Text('刷新'),
                    ),
                    accountStore.isLoggedIn ? 
                      PopupMenuItem(
                        value: ArticlePageHeaderMoreMenuValue.edit,
                        child: Text('编辑此页')
                      )
                    :
                      PopupMenuItem(
                        value: ArticlePageHeaderMoreMenuValue.login,
                        child: Text('登录')
                      )
                    ,
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.toggleWatchList,
                      child: Text((isExistsInWatchList ? '移出' : '加入') + '监视列表')
                    ),
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.share,
                      child: Text('分享'),
                    ),
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.openContents,
                      child: Text('打开目录')
                    )
                  ],
                )
              ),
            ))
          ],
        )
      )
    );
  }
}

enum ArticlePageHeaderMoreMenuValue {
  refresh, edit, login, toggleWatchList, openContents, share
}