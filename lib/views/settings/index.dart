import 'package:flutter/material.dart' hide showAboutDialog;
import 'package:moegirl_plus/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/utils/article_cache_manager.dart';
import 'package:moegirl_plus/utils/reading_history_manager.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/settings/components/item.dart';
import 'package:moegirl_plus/views/settings/utils/show_language_selection_dialog.dart';
import 'package:moegirl_plus/views/settings/utils/show_theme_selection_dialog.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import 'utils/show_about_dialog.dart';

class SettingsPageRouteArgs {
  
  SettingsPageRouteArgs();
}

class SettingsPage extends StatefulWidget {
  final SettingsPageRouteArgs routeArgs;
  SettingsPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void cleanCache() async {
    final result = await showAlert(
      content: l.settingsPage_cleanCacheCheck,
      visibleCloseButton: true
    );
    if (!result) return;

    ArticleCacheManager.clearCache();
    toast(l.settingsPage_cleanCachekDone);
  }

  void clearReadingHistory() async {
    final result = await showAlert(
      content: l.settingsPage_cleanHistoryCheck,
      visibleCloseButton: true
    );
    if (!result) return;

    ReadingHistoryManager.clear();
    toast(l.settingsPage_cleanHistoryDone);
  }
  
  void showThemeDialog() async {
    final result = await showThemeSelectionDialog(
      context: context,
      initialValue: settingsProvider.theme, 
      onChange: (value) => settingsProvider.theme = value
    );

    settingsProvider.theme = result;
  }

  void showLanguageDialog() async {
    final result = await showLanguageSelectionDialog(
      context: context,
      initialValue: settingsProvider.lang, 
    );

    if (settingsProvider.lang != result) toast('修改语言重启后生效', position: ToastPosition.center);
    settingsProvider.lang = result;
  }

  void toggleLoginStatus(bool isLoggedIn) async {
    if (isLoggedIn) {
      final result = await showAlert(
        content: l.settingsPage_logoutCheck,
        visibleCloseButton: true
      );
      if (!result) return;

      accountProvider.logout();
      toast(l.settingsPage_logouted);
    } else {
      OneContext().pushNamed('/login');
    }
  }

  void checkNewVersion() {
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget title(String text) {
      return Padding(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
        child: Text(text,
          style: TextStyle(
            color: theme.accentColor
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(l.settingsPage_title),
        leading: AppBarBackButton(),
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Consumer<SettingsProviderModel>(
            builder: (_, settingsProvider, __) => (
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title(l.settingsPage_article),
                  SettingsPageItem(
                    title: l.settingsPage_heimuSwitch,
                    subtext: l.settingsPage_heimuSwitchHint,
                    onPressed: () => settingsProvider.heimu = !settingsProvider.heimu,
                    rightWidget: Switch(
                      value: settingsProvider.heimu,
                      onChanged: (value) => settingsProvider.heimu = value,
                    ),
                  ),
                  SettingsPageItem(
                    title: l.settingsPage_stopAudioOnLeave,
                    subtext: l.settingsPage_stopAudioOnLeaveHint,
                    onPressed: () => settingsProvider.stopAudioOnLeave = !settingsProvider.stopAudioOnLeave,
                    rightWidget: Switch(
                      value: settingsProvider.stopAudioOnLeave,
                      onChanged: (value) => settingsProvider.stopAudioOnLeave = value,
                    ),
                  ),
                  title(l.settingsPage_interface),
                  SettingsPageItem(
                    title: l.settingsPage_changeTheme,
                    onPressed: showThemeDialog,
                  ),
                  SettingsPageItem(
                    title: l.settingsPage_changeLanguage,
                    onPressed: showLanguageDialog,
                  ),
                  title(l.settingsPage_cache),
                  SettingsPageItem(
                    title: l.settingsPage_cachePriority,
                    subtext: l.settingsPage_cachePriorityHint,
                    onPressed: () => settingsProvider.cachePriority = !settingsProvider.cachePriority,
                    rightWidget: Switch(
                      value: settingsProvider.cachePriority,
                      onChanged: (value) => settingsProvider.cachePriority = value,
                    ),
                  ),
                  SettingsPageItem(
                    title: l.settingsPage_cleanCache,
                    onPressed: cleanCache,
                  ),
                  SettingsPageItem(
                    title: l.settingsPage_cleanReadingHistory,
                    onPressed: clearReadingHistory,
                  ),
                  title(l.settingsPage_account),
                  LoggedInSelector(
                    builder: (isLoggedIn) => (
                      SettingsPageItem(
                        title: l.settingsPage_loginToggle(isLoggedIn),
                        onPressed: () => toggleLoginStatus(isLoggedIn),
                      )
                    ),
                  ),
                  title(l.settingsPage_other),
                  SettingsPageItem(
                    title: l.settingsPage_about,
                    onPressed: () => showAboutDialog(context),
                  ),
                  SettingsPageItem(
                    title: '检查新版本',
                    onPressed: checkNewVersion
                  )
                ],
              )
            ),
          ),
        ),
      )
    );
  }
}