import 'package:moegirl_viewer/request/moe_request.dart';

class WatchListApi {
  // 获取监视状态改用ArticleApi.getPageInfo()，为了少调用一次接口
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

  static Future getRawWatchList([String continueKey]) {
    return moeRequest(
      params: {
        'action': 'query',
        'format': 'json',
        'list': 'watchlistraw',
        'continue': '-||',
        ...(continueKey != null ? { 'wrcontinue': continueKey } : {}),
        'wrlimit': '500'
      }
    );
  }

  static Future<List> getChanges({
    String startISO,
    bool includeMinor,
    bool includeRobot,
    int limit
  }) {
    final List<String> showing = [];
    if (!includeMinor) showing.add('!minor');
    if (!includeRobot) showing.add('!bot');
    
    return moeRequest(
      params: {
        'action': 'query',
        'format': 'json',
        'list': 'watchlist',
        'wlend': startISO,
        'wllimit': limit,
        'wlshow': showing.join('|'),
        'wlallrev': 1,
        'wlprop': 'flags|user|comment|timestamp|ids|title|sizes'
      }
    ).then((data) => data['query']['watchlist']);
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