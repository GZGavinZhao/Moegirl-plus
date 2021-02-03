import 'package:flutter/material.dart' hide showAboutDialog;
import 'package:moegirl_plus/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/utils/article_cache_manager.dart';
import 'package:moegirl_plus/utils/check_new_version.dart';
import 'package:moegirl_plus/utils/reading_history_manager.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/settings/components/item.dart';
import 'package:moegirl_plus/views/settings/utils/show_language_selection_dialog.dart';
import 'package:moegirl_plus/views/settings/utils/show_theme_selection_dialog.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
      content: Lang.settingsPage_cleanCacheCheck,
      visibleCloseButton: true
    );
    if (!result) return;

    ArticleCacheManager.clearCache();
    toast(Lang.settingsPage_cleanCachekDone);
  }

  void clearReadingHistory() async {
    final result = await showAlert(
      content: Lang.settingsPage_cleanHistoryCheck,
      visibleCloseButton: true
    );
    if (!result) return;

    ReadingHistoryManager.clear();
    toast(Lang.settingsPage_cleanHistoryDone);
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

    if (settingsProvider.lang != result) toast(Lang.settingsPage_showLanguageSelectionDialog_changedHint, position: ToastPosition.center);
    settingsProvider.lang = result;
  }

  void toggleLoginStatus(bool isLoggedIn) async {
    if (isLoggedIn) {
      final result = await showAlert(
        content: Lang.settingsPage_logoutCheck,
        visibleCloseButton: true
      );
      if (!result) return;

      accountProvider.logout();
      toast(Lang.settingsPage_logouted);
    } else {
      OneContext().pushNamed('/login');
    }
  }

  void checkVersion() async {
    showLoading();
    try {
      final newVersion = await checkNewVersion();
      if (newVersion == null) return toast(Lang.settingsPage_noNewVersion);

      final result = await showAlert(
        title: Lang.hasNewVersionHint,
        content: newVersion.desc,
        visibleCloseButton: true,
      );

      if (!result) return;
      launch('https://www.coolapk.com/apk/247471');
    } catch(e) {
      print('检查新版本失败');
      print(e);
      toast(Lang.netErr);
    } finally {
      OneContext().pop();
    }
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
        title: AppBarTitle(Lang.settingsPage_title),
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
                  title(Lang.settingsPage_article),
                  SettingsPageItem(
                    title: Lang.settingsPage_heimuSwitch,
                    subtext: Lang.settingsPage_heimuSwitchHint,
                    onPressed: () => settingsProvider.heimu = !settingsProvider.heimu,
                    rightWidget: Switch(
                      value: settingsProvider.heimu,
                      onChanged: (value) => settingsProvider.heimu = value,
                    ),
                  ),
                  SettingsPageItem(
                    title: Lang.settingsPage_stopAudioOnLeave,
                    subtext: Lang.settingsPage_stopAudioOnLeaveHint,
                    onPressed: () => settingsProvider.stopAudioOnLeave = !settingsProvider.stopAudioOnLeave,
                    rightWidget: Switch(
                      value: settingsProvider.stopAudioOnLeave,
                      onChanged: (value) => settingsProvider.stopAudioOnLeave = value,
                    ),
                  ),
                  title(Lang.settingsPage_interface),
                  SettingsPageItem(
                    title: Lang.settingsPage_changeTheme,
                    onPressed: showThemeDialog,
                  ),
                  SettingsPageItem(
                    title: Lang.settingsPage_changeLanguage,
                    onPressed: showLanguageDialog,
                  ),
                  title(Lang.settingsPage_cache),
                  SettingsPageItem(
                    title: Lang.settingsPage_cachePriority,
                    subtext: Lang.settingsPage_cachePriorityHint,
                    onPressed: () => settingsProvider.cachePriority = !settingsProvider.cachePriority,
                    rightWidget: Switch(
                      value: settingsProvider.cachePriority,
                      onChanged: (value) => settingsProvider.cachePriority = value,
                    ),
                  ),
                  SettingsPageItem(
                    title: Lang.settingsPage_cleanCache,
                    onPressed: cleanCache,
                  ),
                  SettingsPageItem(
                    title: Lang.settingsPage_cleanReadingHistory,
                    onPressed: clearReadingHistory,
                  ),
                  title(Lang.settingsPage_account),
                  LoggedInSelector(
                    builder: (isLoggedIn) => (
                      SettingsPageItem(
                        title: Lang.settingsPage_loginToggle(isLoggedIn),
                        onPressed: () => toggleLoginStatus(isLoggedIn),
                      )
                    ),
                  ),
                  title(Lang.settingsPage_other),
                  SettingsPageItem(
                    title: Lang.settingsPage_about,
                    onPressed: () => showAboutDialog(context),
                  ),
                  SettingsPageItem(
                    title: Lang.settingsPage_checkNewVersion,
                    onPressed: checkVersion
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