import 'package:flutter/material.dart' hide showAboutDialog;
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/settings.dart';
import 'package:moegirl_viewer/utils/article_cache_manager.dart';
import 'package:moegirl_viewer/utils/reading_history_manager.dart';
import 'package:moegirl_viewer/utils/ui/dialog/index.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
import 'package:moegirl_viewer/views/settings/components/item.dart';
import 'package:moegirl_viewer/views/settings/utils/show_theme_selection_dialog.dart';
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
  
  void clearCache() async {
    final result = await CommonDialog.alert(
      content: '确定要清除全部条目缓存吗？',
      visibleCloseButton: true
    );
    if (!result) return;

    ArticleCacheManager.clearCache();
    toast('已清除全部缓存');
  }

  void clearReadingHistory() async {
    final result = await CommonDialog.alert(
      content: '确定要清除全部浏览历史吗？',
      visibleCloseButton: true
    );
    if (!result) return;

    ReadingHistoryManager.clear();
    toast('已清除全部浏览历史');
  }
  
  void showThemeDialog() async {
    final result = await showThemeSelectionDialog(
      initialValue: settingsProvider.theme, 
      onChange: (value) => settingsProvider.theme = value
    );

    settingsProvider.theme = result;
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
        title: Text('设置'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Consumer<SettingsProviderModel>(
            builder: (_, settingsProvider, __) => (
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title('条目'),
                  SettingsPageItem(
                    title: '黑幕开关',
                    subtext: '关闭后黑幕将默认为刮开状态',
                    onPressed: () => settingsProvider.heimu = !settingsProvider.heimu,
                    rightWidget: Switch(
                      value: settingsProvider.heimu,
                      onChanged: (value) => settingsProvider.heimu = value,
                    ),
                  ),
                  SettingsPageItem(
                    title: '停止旧页面背景媒体',
                    subtext: '打开新条目时停止旧条目上的音频和视频',
                    onPressed: () => settingsProvider.stopAudioOnLeave = !settingsProvider.stopAudioOnLeave,
                    rightWidget: Switch(
                      value: settingsProvider.stopAudioOnLeave,
                      onChanged: (value) => settingsProvider.stopAudioOnLeave = value,
                    ),
                  ),
                  title('界面'),
                  SettingsPageItem(
                    title: '更换主题',
                    onPressed: showThemeDialog,
                  ),
                  title('缓存'),
                  SettingsPageItem(
                    title: '缓存优先模式',
                    subtext: '如果有条目有缓存将优先使用',
                    onPressed: () => settingsProvider.cachePriority = !settingsProvider.cachePriority,
                    rightWidget: Switch(
                      value: settingsProvider.cachePriority,
                      onChanged: (value) => settingsProvider.cachePriority = value,
                    ),
                  ),
                  SettingsPageItem(
                    title: '清除条目缓存',
                    onPressed: () {},
                  ),
                  SettingsPageItem(
                    title: '清除浏览历史',
                    onPressed: () {},
                  ),
                  title('账户'),
                  Selector<AccountProviderModel, bool>(
                    selector: (_, model) => model.isLoggedIn,
                    builder: (_, isLoggedIn, __) => (
                      SettingsPageItem(
                        title: isLoggedIn ? '登出' : '登录',
                        onPressed: () {},
                      )
                    ),
                  ),
                  title('其他'),
                  SettingsPageItem(
                    title: '关于',
                    onPressed: showAboutDialog,
                  ),
                  SettingsPageItem(
                    title: '检查新版本',
                    onPressed: () {}
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