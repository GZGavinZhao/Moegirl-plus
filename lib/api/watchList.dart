import 'package:moegirl_viewer/request/moe_request.dart';

class WatchList {
  static Future<bool> isWatched(String pageName) {
    return moeRequest(
      params: {
        'action': 'query',
        'prop': 'info',
        'titles': pageName,
        'inprop': 'watched',
        'intestactions': ''
      }
    )
      .then((data) {
        final Map pageData = data['query']['pages'].values.toList()[0];
        return pageData.containsKey('watched');
      });
  }

  static setWatchStatus(String pageName, bool watch) async {
    final tokenData = await _getToken();
    final token = tokenData['query']['tokens']['watchtoken'];
    return _setWatchStatus(token, pageName, watch);
  }
}

Future<Map> _getToken() {
  return moeRequest(
    params: {
      'action': 'query',
      'meta': 'tokens',
      'type': 'watch'
    }
  );
}

Future<Map> _setWatchStatus(String token, String pageName, bool watch) async {
  return moeRequest(
    method: 'post',
    params: {
      'action': 'watch',
      ...(watch ? {} : { 'unwatch': 1 }),
      'titles': pageName,
      'redirects': 1,
      'token': token
    }
  );
}