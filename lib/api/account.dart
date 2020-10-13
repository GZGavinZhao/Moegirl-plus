import 'package:moegirl_viewer/request/moe_request.dart';

Future _login(String token, String userName, String password) {
  return moeRequest(
    method: 'post',
    params: {
      'action': 'clientlogin',
      'loginmessageformat': 'html',
      'loginreturnurl': 'https://zh.moegirl.org/Mainpage',
      'username': userName, 
      'password': password,
      'rememberMe': true,
      'logintoken': token    
    }
  );
}

class AccountApi {
  static Future getToken() {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'query',
        'meta': 'tokens',
        'type': 'login'
      }
    );
  }

  static Future login(String userName, String password) async {
    final tokenData = await getToken();
    final String token = tokenData['query']['tokens']['logintoken'];
    return _login(token, userName, password);
  }
  
  static Future logout() {
    return moeRequest(
      method: 'post',
      params: { 'action': 'logout' }
    );
  }

  static Future getInfo() {
    return moeRequest(params: {
      'action': 'query',
      'meta': 'userinfo',
      'uiprop': 'implicitgroups'
    });
  }
}