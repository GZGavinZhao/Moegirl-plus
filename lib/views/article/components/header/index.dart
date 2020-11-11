import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:one_context/one_context.dart';

import 'components/animation.dart';

class ArticlePageHeader extends StatelessWidget {
  final String title;
  final bool isExistsInWatchList;
  final bool enabledMoreButton;
  final bool editAllowed; // 为null时视为正在从接口获取权限
  final bool editFullDisabled;
  final bool visibleTalkButton;
  final Function(ArticlePageHeaderAnimationController) emitController;
  final Function(ArticlePageHeaderMoreMenuValue) onMoreMenuPressed;
  
  const ArticlePageHeader({
    @required this.title,
    @required this.isExistsInWatchList,
    @required this.enabledMoreButton,
    @required this.editAllowed,
    @required this.editFullDisabled,
    @required this.visibleTalkButton,
    @required this.onMoreMenuPressed,
    @required this.emitController,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ArticlePageHeaderAnimation(
      emitController: emitController,
      fadedChildBuilder: (faded) => (
        AppBar(
          elevation: 0,
          title: faded(AppBarTitle(title)),
          leading: Builder(
            builder: (context) => faded(AppBarBackButton())
          ),
          actions: [
            faded(AppBarIcon(
              icon: Icons.search, 
              onPressed: () => OneContext().pushNamed('search')
            )),
            faded(LoggedInSelector(
              builder: (isLoggedIn) => (
                PopupMenuButton(
                  icon: Icon(Icons.more_vert,
                    color: theme.colorScheme.onPrimary,
                  ),
                  enabled: enabledMoreButton,
                  tooltip: '更多选项',
                  onSelected: onMoreMenuPressed,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.refresh,
                      child: Text('刷新'),
                    ),
                    isLoggedIn ? 
                      PopupMenuItem(
                        value: editFullDisabled ? ArticlePageHeaderMoreMenuValue.addSection : ArticlePageHeaderMoreMenuValue.edit,
                        enabled: editAllowed != null && editAllowed,
                        child: Text(
                          editAllowed == null ?
                            '检查权限中' :
                            (editAllowed ? 
                              (editFullDisabled ? 
                                '添加话题' : 
                                '编辑此页'
                              ) :
                              '无权编辑此页'
                            )
                        )
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
                    if (visibleTalkButton) (
                      PopupMenuItem(
                        value: ArticlePageHeaderMoreMenuValue.gotoTalk,
                        child: Text('前往讨论页'),
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
  refresh, edit, login, toggleWatchList, openContents, share, addSection, gotoTalk
}