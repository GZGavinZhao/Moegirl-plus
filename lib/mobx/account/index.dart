import 'package:mobx/mobx.dart';
import 'package:moegirl_viewer/api/account.dart';
import 'package:moegirl_viewer/prefs/index.dart';

part 'index.g.dart';

class AccountStore = _AccountBase with _$AccountStore;


abstract class _AccountBase with Store {
  @observable String userName = accountPref.userName;
  @observable int waitingNotificationTotal = 0;
  @observable dynamic userInfo;

  @computed bool get isLoggedIn => userName != null;
  @computed Future<bool> get isAutoConfirmed async {
    final userInfo = await this.getUserInfo();
    return userInfo['implicitgroups'].contains('autoconfirmed');
  }

  @action
  Future<LoginResult> login(String userName, String password) async {
    final res = await AccountApi.login(userName, password);
    if (res['clientlogin']['status'] == 'PASS') {
      this.userName = userName;
      accountPref.userName = userName;
      return LoginResult(true);
    } else {
      return LoginResult(false, res['clientlogin']['message']);
    }
  }

  @action
  Future<bool> checkAccount() async {

  }

  @action
  Future checkWaitingNotificationTotal() async {

  }

  @action
  Future getUserInfo() async {
    if (userInfo != null) return userInfo;
    final res = await AccountApi.getInfo();
    userInfo = res['query']['userinfo'];
    return userInfo;
  }
}

class LoginResult {
  final bool successed;
  final String message;

  LoginResult(this.successed, [this.message]);
}