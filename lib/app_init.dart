import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/providers/account.dart';

mixin AppInit<T extends StatefulWidget> on State<T>, AfterLayoutMixin<T> {
  Timer _notificationCheckingTimer;
  
  @override
  void afterFirstLayout(_) { 
    // 初始化用户信息，开始轮询检查等待通知
    accountProvider.getUserInfo();
    accountProvider.checkWaitingNotificationTotal();
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
    _notificationCheckingTimer.cancel();
  }
}