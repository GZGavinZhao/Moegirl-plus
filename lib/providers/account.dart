import 'package:flutter/cupertino.dart';
import 'package:moegirl_viewer/api/account.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class AccountProviderModel with ChangeNotifier {
  String userName = accountPref.userName;
  int waitingNotificationTotal = 0;
  dynamic userInfo;

  bool get isLoggedIn => userName != null;

  Future<bool> get isAutoConfirmed async {
    final userInfo = await this.getUserInfo();
    return userInfo['implicitgroups'].contains('autoconfirmed');
  }

  Future<LoginResult> login(String userName, String password) async {
    final res = await AccountApi.login(userName, password);
    if (res['clientlogin']['status'] == 'PASS') {
      this.userName = userName;
      accountPref.userName = userName;
      notifyListeners();
      return LoginResult(true);
    } else {
      return LoginResult(false, res['clientlogin']['message']);
    }
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
}

final accountProvider = Provider.of<AccountProviderModel>(OneContext().context, listen: false);

class LoginResult {
  final bool successed;
  final String message;

  LoginResult(this.successed, [this.message]);
}