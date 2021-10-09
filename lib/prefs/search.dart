// @dart=2.9
import 'package:moegirl_plus/utils/runtime_constants.dart';

import 'index.dart';

class SearchingHistoryPref extends PrefManager {
  final prefStorage = PrefStorage.searchingHistory;
  String get listName => RuntimeConstants.source + '-list';
  List get _list => getPref(listName, []);

  List<SearchingHistory> getList() {
    return _list.map<SearchingHistory>((item) => SearchingHistory.fromMap(item)).toList();
  }

  Future<bool> add(SearchingHistory searchingHistory) {
    _list.removeWhere((item) => item['keyword'] == searchingHistory.keyword);
    _list.insert(0, searchingHistory.toMap());
    return setPref(listName, _list);
  }

  Future<bool> remove(String keyword) {
    _list.removeWhere((item) => item['keyword'] == keyword);
    return setPref(listName, _list);
  }

  Future<bool> clear() {
    return removePref(listName);
  }
}

class SearchingHistory {
  final String keyword;
  final bool byHint;

  SearchingHistory(this.keyword, this.byHint);

  SearchingHistory.fromMap(Map map) :
    keyword = map['keyword'],
    byHint = map['byHint']
  ;

  Map toMap() {
    return {
      'keyword': keyword,
      'byHint': byHint
    };
  }
}