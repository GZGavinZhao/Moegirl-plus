import 'package:moegirl_viewer/api/edit.dart';
import 'package:moegirl_viewer/request/moe_request.dart';

Future _execMarkAllAsRead(String token) {
  return moeRequest(
    method: 'post',
    params: {
      'action': 'echomarkread',
      'all': 1,
      'token': token
    }
  );
}

class NotificationApi {
  static Future getList([String continueKey, int limit = 50]) {
    return moeRequest(
      params: {
        'action': 'query',
        'meta': 'notifications',
        'notunreadfirst': 1,
        'notalertunreadfirst': 1,
        'formatversion': 2,
        'notlimit': limit,
        'notprop': 'list|count',
        'notsections': 'message|alert',
        'notformat': 'model',
        'notcrosswikisummary': 1,
        ...(continueKey != null ? { 'notcontinue': continueKey } : {})
      }
    );
  }

  static Future<bool> markAllAsRead() async {
    final tokenData = await EditApi.getCsrfToken();
    final result = await _execMarkAllAsRead(tokenData['query']['tokens']['csrftoken']);

    return result['query']['echomarkread']['result'] == 'success';
  }
}