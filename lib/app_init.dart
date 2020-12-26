import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/themes.dart';
import 'package:moegirl_plus/utils/provider_change_checker.dart';
import 'package:moegirl_plus/utils/ui/set_status_bar.dart';
import 'package:moegirl_plus/utils/watch_list_manager.dart';

mixin AppInit<T extends StatefulWidget> on 
  State<T>, 
  AfterLayoutMixin<T>, 
  ProviderChangeChecker<T> 
{
  Timer _notificationCheckingTimer;
  
  @override
  void afterFirstLayout(_) { 
    // 初始化用户信息，开始轮询检查等待通知
    if (accountProvider.isLoggedIn) {
      initUserInfo();
    } 

    if (settingsProvider.theme == 'night') {
      setNavigationBarStyle(nightPrimaryColor, Brightness.light);
    }

    // 监听登录状态，更新用户信息及启动或关闭轮询检查等待通知
    addChangeChecker<AccountProviderModel, bool>(
      provider: accountProvider,
      selector: (provider) => provider.isLoggedIn,
      handler: (isLoggedIn) {
        if (isLoggedIn) {
          initUserInfo();
        } else {
          _notificationCheckingTimer.cancel();
        }
      }
    );

    // 监听主题变化，修改底部导航栏样式
    addChangeChecker<SettingsProviderModel, bool>(
      provider: settingsProvider, 
      selector: (provider) => provider.theme == 'night', 
      handler: (isNight) {
        setNavigationBarStyle(
          isNight ? nightPrimaryColor : Colors.white,
          isNight ? Brightness.light : Brightness.light
        );
      }
    );
  }

  void initUserInfo() {
    accountProvider.getUserInfo();
    accountProvider.checkWaitingNotificationTotal();
    WatchListManager.refreshList();

    _notificationCheckingTimer = Timer.periodic(Duration(seconds: 30), (_) {
      try {
        accountProvider.checkWaitingNotificationTotal();
      } catch(e) {
        print('轮询检查等待通知失败');
        print(e);
      }
    });  
  }

  @override
  void dispose() {
    super.dispose();
    if (_notificationCheckingTimer != null) _notificationCheckingTimer.cancel();
  }
}