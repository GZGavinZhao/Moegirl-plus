import 'package:moegirl_plus/request/moe_request.dart';

class CategoryApi {
  static Future searchByCategory(String categoryName, int thumbSize, [Map continueKey]) {
    return moeRequest(
      params: {
        'action': 'query',
        'prop': 'pageimages|categories',
        'cllimit': 500,
        'generator': 'categorymembers',
        'pilimit': '50',
        'gcmtitle': 'Category:' + categoryName,
        'gcmprop': 'sortkey|sortkeyprefix',
        'gcmnamespace': '0',
        ...(continueKey ?? {}),
        'gcmlimit': '50',
        'pithumbsize': thumbSize,
        'clshow': '!hidden'
      }
    );
  }

  static Future getSubCategory(String categoryName, String continueKey) {
    return moeRequest(
      params: {
        'action': 'query',
        'format': 'json',
        'list': 'categorymembers',
        'cmtitle': 'Category:$categoryName',
        'cmprop': 'title',
        'cmtype': 'subcat',
        'cmlimit': 100,
        'continue': '-||',
        ...(continueKey != null ? {
          'cmcontinue': continueKey
        } : {})
      }
    );
  }

  static Future getCategoryInfo(List<String> categoryNames) {
    return moeRequest(
      params: {
        'action': 'query',
        'format': 'json',
        'prop': 'categoryinfo',
        'titles': categoryNames.map((item) => 'Category:' + item).join('|')
      }
    );
  }
}