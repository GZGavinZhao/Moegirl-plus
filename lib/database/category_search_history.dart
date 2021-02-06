import 'package:sqflite/sqflite.dart';

import 'index.dart';

final tableName = MyDatabases.categorySearchHistory.toString();

class CategorySearchHistoryManager {
  static Future<void> initialize(Database db) async {
    await db.execute('DROP TABLE $tableName;');
    await db.execute('''
      CREATE TABLE $tableName (
        id           INTEGER   AUTOINCREMENT,
        categories   STRING   
      );  
    ''');
  }
  
  static Future<void> add(List<String> categories) async {    
    await CategorySearchHistoryManager.remove(categories);
    await db.insert(tableName, { 'categories': categories.join(',') });
  }

  static Future<void> remove(List<String> categories) async {
    final rawAllList = await db.query(tableName);
    final allList = rawAllList.map((item) => CategorySearchHistory.fromMap(item)).cast<CategorySearchHistory>().toList();
    final foundId = allList.firstWhere((item) => item.matchCategories(categories)).id;

    await db.delete(tableName, where: 'id = ?', whereArgs: [foundId]);
  }

  static Future<List<CategorySearchHistory>> getList() async {
    final rawAllList = await db.query(tableName);
    return rawAllList.map((item) => CategorySearchHistory.fromMap(item));
  }
}

class CategorySearchHistory {
  int id;
  List<String> categories;

  CategorySearchHistory({
    this.id = -1,
    this.categories
  });

  CategorySearchHistory.fromMap(Map map) {
    id = map['id'];
    categories = map['categories'].split(',');
  }

  bool matchCategories(List<String> categories) {
    return this.categories.every((item) => categories.contains(item));
  }
}