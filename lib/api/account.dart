import 'package:moegirl_plus/api/edit.dart';
import 'package:moegirl_plus/request/moe_request.dart';

Future<Map> _login(String token, String userName, String password) {
  return moeRequest(
    method: 'post',
    params: {
      'action': 'clientlogin',
      'loginmessageformat': 'html',
      'loginreturnurl': 'https://zh.moegirl.org.cn/Mainpage',
      'username': userName, 
      'password': password,
      'rememberMe': true,
      'logintoken': token    
    }
  );
}

class AccountApi {
  static Future<Map> getLoginToken() {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'query',
        'meta': 'tokens',
        'type': 'login'
      }
    );
  }

  static Future<Map> login(String userName, String password) async {
    final tokenData = await getLoginToken();
    final String token = tokenData['query']['tokens']['logintoken'];
    return _login(token, userName, password);
  }
  
  static Future logout() {
    return moeRequest(
      method: 'post',
      params: { 'action': 'logout' }
    );
  }

  static Future<Map> getInfo() {
    return moeRequest(params: {
      'action': 'query',
      'meta': 'userinfo',
      'uiprop': 'groups|blockinfo'
    });
  }

  static Future poll(String pollId, int answer, String token) async {
    return moeRequest(
      baseUrl: 'https://zh.moegirl.org.cn/index.php',
      params: {
        'action': 'ajax',
        'rs': 'AJAXPoll::submitVote',
        'rsargs': [pollId, answer, token]
      }
    );
  }
}