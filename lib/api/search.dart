import 'package:moegirl_viewer/request/moe_request.dart';

class SearchApi {
  static Future getHint(String keyword, [int limit = 10]) {
    return moeRequest(
      params: {
        'action': 'query',
        'list': 'search',
        'srsearch': keyword,
        'srlimit': limit,
        'srwhat': 'text'
      }
    );
  }

  static Future search(String keyword, int offset) {
    return moeRequest(
      params: {
        'action': 'query',
        'list': 'search',
        'srsearch': keyword,
        'continue': '-||',
        'sroffset': offset,
        'srprop': 'timestamp|redirecttitle|snippet|categoriesnippet|sectiontitle|pageimages',
        'srenablerewrites': 1
      }
    );
  }
}