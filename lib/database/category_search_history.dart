import 'package:sqflite/sqflite.dart';

import 'index.dart';

final tableName = 'categorySearchHistory';

class CategorySearchHistoryManager {
  static Future<void> initialize(Database db) async {
    if (await hasDatabaseTable(db, tableName)) await db.execute('DROP TABLE $tableName;');

    await db.execute('''
      CREATE TABLE $tableName (
        id           INTEGER    PRIMARY KEY    AUTOINCREMENT,
        categories   STRING   
      );  
    ''');
  }
  
  static Future<void> add(CategorySearchHistory history) async {    
    await CategorySearchHistoryManager.remove(history);
    await db.insert(tableName, { 'categories': history.toString() });
  }

  static Future<void> remove(CategorySearchHistory history) async {
    final rawAllList = await db.query(tableName);
    final allList = rawAllList.map((item) => CategorySearchHistory.fromMap(item)).cast<CategorySearchHistory>().toList();
    final foundItem = allList.firstWhere((item) => item.matchCategories(history), orElse: () => null);

    if (foundItem != null) await db.delete(tableName, where: 'id = ?', whereArgs: [foundItem.id]);
  }

  static Future<List<CategorySearchHistory>> getList() async {
    final rawAllList = await db.query(tableName);
    return rawAllList.map((item) => CategorySearchHistory.fromMap(item))
      .cast<CategorySearchHistory>()
      .toList()
      .reversed
      .toList();
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