import 'index.dart';

class SearchingHistory {
  String keyword;
  bool byHint;

  SearchingHistory(Map map) {
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
  get _list => getItem('list', []);

  List<SearchingHistory> getList() {
    return _list.map((item) => SearchingHistory(item)).toList();
  }

  Future<bool> top(String keyword) {
    final foundIndex = _list.indexWhere((item) => item['keyword'] == keyword);
    if (foundIndex == -1) return Future(() => false);

    final foundItem = _list.removeAt(foundIndex);
    _list.insert(0, foundItem);
    return setItem('list', _list);
  }

  Future<bool> add(SearchingHistory searchingHistory) {
    _list.add(searchingHistory.toMap());
    return setItem('list', _list);
  }

  Future<bool> clear() {
    return removeItem('list');
  }
}