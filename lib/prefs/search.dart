import 'index.dart';

class SearchingHistory {
  String keyword;
  bool byHint;

  SearchingHistory(this.keyword, this.byHint);

  SearchingHistory.fromMap(Map map) {
    this.keyword = map['keyword'];
    this.byHint = map['byHint'];
  }

  Map toMap() {
    return {
      'keyword': keyword,
      'byHint': byHint
    };
  }
}

class SearchingHistoryPref extends PrefManager {
  final prefStorage = PrefStorage.searchingHistory;
  List get _list => getPref('list', []);

  List<SearchingHistory> getList() {
    return _list.map<SearchingHistory>((item) => SearchingHistory.fromMap(item)).toList();
  }

  Future<bool> add(SearchingHistory searchingHistory) {
    _list.removeWhere((item) => item['keyword'] == searchingHistory.keyword);
    _list.insert(0, searchingHistory.toMap());
    return setPref('list', _list);
  }

  Future<bool> remove(String keyword) {
    _list.removeWhere((item) => item['keyword'] == keyword);
    return setPref('list', _list);
  }

  Future<bool> clear() {
    return removePref('list');
  }
}