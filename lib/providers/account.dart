// @dart=2.9
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/api/account.dart';
import 'package:moegirl_plus/api/edit.dart';
import 'package:moegirl_plus/api/notification.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class AccountProviderModel with ChangeNotifier {
  String get userName => accountPref.userName;
  set userName(String value) => accountPref.userName = value;
  int waitingNotificationTotal = 0;
  dynamic userInfo;

  bool get isLoggedIn => userName != null;

  Future<LoginResult> login(String userName, String password) async {
    final res = await AccountApi.login(userName, password);
    if (res['clientlogin']['status'] == 'PASS') {
      this.userName = userName;
      notifyListeners();
      return LoginResult(true);
    } else {
      return LoginResult(false, res['clientlogin']['message']);
    }
  }

  void logout() {
    AccountApi.logout();
    userName = null;
    notifyListeners();
  }

  Future<bool> checkAccount() async {
    try {
      final data = await EditApi.getCsrfToken();
      if (data['query']['tokens']['csrftoken'] != '+\\') return true;
      logout();
      return false;
    } catch(e) {
      print('检查账户有效性失败');
      print(e);
      return true;  // 因为萌百服务器不稳定，所以将网络超时认定为有效
    }
  }

  Future<int> checkWaitingNotificationTotal() async {
    final data = await NotificationApi.getList('', 1);
    waitingNotificationTotal = data['query']['notifications']['rawcount'];
    notifyListeners();
    return waitingNotificationTotal;
  }

  Future<void> markAllNotificationAsRead() async {
    await NotificationApi.markAllAsRead();
    waitingNotificationTotal = 0;
    notifyListeners();
  }

  Future getUserInfo() async {
    if (userInfo != null) return userInfo;
    final res = await AccountApi.getInfo();
    if (res['query']['userinfo'].containsKey('anon')) return;
    
    userInfo = res['query']['userinfo'];
    notifyListeners();
    return userInfo;
  }

  Future<bool> inUserGroup(UserGroups userGroup) async {
    final userInfo = await getUserInfo();
    final groupName = userGroup.toString().replaceAll('UserGroups.', '').toLowerCase();
    return userInfo['groups'].contains(groupName);
  }
}

AccountProviderModel get accountProvider => Provider.of<AccountProviderModel>(OneContext().context, listen: false);

class LoginResult {
  final bool successed;
  final String message;

  LoginResult(this.successed, [this.message]);
}

enum UserGroups {
  autoConfirmed, goodEditor, patroller
}