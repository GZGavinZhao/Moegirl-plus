import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/account.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class AccountProviderModel with ChangeNotifier {
  String get userName => accountPref.userName;
  set userName(String value) => accountPref.userName = value;
  int waitingNotificationTotal = 0;
  dynamic userInfo;

  bool get isLoggedIn => userName != null;

  AccountProviderModel() {
    getUserInfo();
  }

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

  }

  Future checkWaitingNotificationTotal() async {

  }

  Future getUserInfo() async {
    if (userInfo != null) return userInfo;
    final res = await AccountApi.getInfo();
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

final accountProvider = Provider.of<AccountProviderModel>(OneContext().context, listen: false);

class LoginResult {
  final bool successed;
  final String message;

  LoginResult(this.successed, [this.message]);
}

enum UserGroups {
  autoConfirmed, goodEditor, patroller
}