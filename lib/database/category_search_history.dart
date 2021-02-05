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
    await CategorySearchHistoryManager.remove(categories.join(','));
    await db.insert(tableName, { 'categories': categories.join(',') });
  }

  static Future<void> remove(List<String> categories) async {
    final rawAllList = await db.query(tableName);
    final allList = rawAllList.map((item) => CategorySearchHistory.fromMap(item)).cast<CategorySearchHistory>().toList();
    final foundIndex = allList.indexWhere((item) => categories.every((category) => category == item));
    // await db.delete(tableName, where: 'pageName = ?', whereArgs: [pageName]);
  }

  static Future<List<CategorySearchHistory>> getList() async {
    final rawData = await db.query(tableName, columns: ['categories']);
    
    // return rawData.map((key, value) => CategorySearchHistory.fromMap())
  }
}

class CategorySearchHistory {
  List<String> categories;

  CategorySearchHistory({
    this.categories
  });

  CategorySearchHistory.fromMap(Map map) {
    categories = map['categories'].split(',');
  }
}