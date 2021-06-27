import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:one_context/one_context.dart';

import 'components/animation.dart';

class ArticlePageHeader extends StatelessWidget {
  final String title;
  final bool isExistsInWatchList;
  final bool enabledMoreButton;
  final bool editAllowed; // 为null时视为正在从接口获取权限
  final bool editFullDisabled;  // 是否允许编辑全文
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
          brightness: Brightness.dark,
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
                  tooltip: Lang.moreOptions,
                  onSelected: onMoreMenuPressed,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.refresh,
                      child: Text(Lang.refresh),
                    ),
                    isLoggedIn ? 
                      PopupMenuItem(
                        value: editFullDisabled ? ArticlePageHeaderMoreMenuValue.addSection : ArticlePageHeaderMoreMenuValue.edit,
                        enabled: editAllowed != null && editAllowed,
                        child: Text(
                          editAllowed == null ?
                            Lang.moreMenuEditButton('permissionsChecking') :
                            (editAllowed ? 
                              (editFullDisabled ? 
                                Lang.moreMenuEditButton('addTheme') : 
                                Lang.moreMenuEditButton('full')
                              ) :
                              Lang.moreMenuEditButton('disabled')
                            )
                        )
                      )
                    :
                      PopupMenuItem(
                        value: ArticlePageHeaderMoreMenuValue.login,
                        child: Text(Lang.login)
                      )
                    ,
                    if (isLoggedIn) (
                      PopupMenuItem(
                        value: ArticlePageHeaderMoreMenuValue.toggleWatchList,
                        child: Text(Lang.watchListOperateHint(isExistsInWatchList))
                      )
                    ),
                    if (visibleTalkButton) (
                      PopupMenuItem(
                        value: ArticlePageHeaderMoreMenuValue.gotoTalk,
                        child: Text(Lang.talk),
                      )
                    ),
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.gotoVersionHistory,
                      child: Text(Lang.pageVersionHistory),
                    ),
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.share,
                      child: Text(Lang.share),
                    ),
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.findInPage,
                      child: Text(Lang.findInPage),
                    ),
                    PopupMenuItem(
                      value: ArticlePageHeaderMoreMenuValue.openContents,
                      child: Text(Lang.showContents)
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
  refresh, 
  edit, 
  login, 
  toggleWatchList, 
  openContents, 
  share, 
  addSection, 
  gotoTalk, 
  gotoVersionHistory,
  findInPage
}