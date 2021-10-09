// @dart=2.9
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/utils/media_wiki_namespace.dart';

class SearchApi {
  static Future getHint(String keyword, {
    int limit = 20, 
    MediaWikiNamespace namespace
  }) {
    return moeRequest(
      params: {
        'action': 'query',
        'list': 'search',
        'srsearch': keyword,
        'srlimit': limit,
        'srwhat': 'text',
        ...(namespace != null ? { 'srnamespace': getNsCode(namespace) } : {})
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
      }
    );
  }
}