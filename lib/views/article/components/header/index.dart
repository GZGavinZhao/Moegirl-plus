import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/styled/app_bar_icon.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return ArticlePageHeaderAnimation(
      emitController: emitController,
      fadedChildBuilder: (faded) => (
        AppBar(
          elevation: 0,
          title: faded(Text(title)),
          leading: Builder(
            builder: (context) => faded(AppBarIcon(
              icon: Icons.arrow_back,
              onPressed: () => OneContext().pop()
            ))
          ),
          actions: [
            faded(AppBarIcon(
              icon: Icons.search, 
              onPressed: () => OneContext().pushNamed('search')
            )),
            faded(Selector<AccountProviderModel, bool>(
              selector: (_, model) => model.isLoggedIn,
              builder: (_, isLoggedIn, __) => (
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  tooltip: '更多选项',
                  onSelected: onMoreMenuPressed,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.refresh,
                      child: Text('刷新'),
                    ),
                    isLoggedIn ? 
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
                    if (isLoggedIn) (
                      PopupMenuItem(
                        value: ArticlePageHeaderMoreMenuValue.toggleWatchList,
                        child: Text((isExistsInWatchList ? '移出' : '加入') + '监视列表')
                      )
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