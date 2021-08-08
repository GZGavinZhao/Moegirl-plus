import 'package:moegirl_plus/database/category_search_history/patches/v2.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';

import '../index.dart';

final _tableName = getDatabaseName(MyDatabaseTable.categorySearchHistory);

class CategorySearchHistoryDbClient {
  static Future<void> initialize() async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id           INTEGER    PRIMARY KEY    AUTOINCREMENT,
        source       TEXT,   
        categories   TEXT
      );  
    ''');
  }
  
  static List<DatabasePatch> patches = [
    categorySearchHistoryDbPatchV2
  ];
  
  static Future<List<CategorySearchHistory>> getList() async {
    final rawAllList = await db.query(_tableName, where: 'source = ?', whereArgs: [RuntimeConstants.source]);
    return rawAllList.map((item) => CategorySearchHistory.fromMap(item))
      .cast<CategorySearchHistory>()
      .toList()
      .reversed
      .toList();
  }

  static Future<void> add(CategorySearchHistory history) async {    
    await CategorySearchHistoryDbClient.remove(history);
    await db.insert(_tableName, { 
      'source': RuntimeConstants.source,
      'categories': history.toString() 
    });
  }

  static Future<void> remove(CategorySearchHistory history) async {
    final rawAllList = await db.query(_tableName, where: 'source = ?', whereArgs: [RuntimeConstants.source]);
    final allList = rawAllList.map((item) => CategorySearchHistory.fromMap(item)).cast<CategorySearchHistory>().toList();
    final foundItem = allList.firstWhere((item) => item.matchCategories(history), orElse: () => null);

    if (foundItem != null) await db.delete(_tableName, where: 'id = ?', whereArgs: [foundItem.id]);
  }

  static Future<void> clear() async {
    await db.delete(_tableName);
  }
}

class CategorySearchHistory {
  int id;
  List<String> categories;

  CategorySearchHistory({
    this.id,
    this.categories
  });

  CategorySearchHistory.fromMap(Map map) {
    id = map['id'];
    categories = map['categories'].split(',');
  }

  CategorySearchHistory.fromCategories(List<String> categories) {
    id = -1;
    this.categories = [...categories];
  }

  bool matchCategories(CategorySearchHistory history) {
    if (categories.length != history.categories.length) return false;
    return this.categories.every((item) => history.categories.contains(item));
  }

  String toString() {
    return categories.join(',');
  }
}