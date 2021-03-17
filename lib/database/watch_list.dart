import 'index.dart';

final _tableName = getDatabaseName(MyDatabaseTable.watchList);

class WatchListManagerDbClient {
  static Future<void> initialize() async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id           INTEGER    PRIMARY KEY    AUTOINCREMENT,
        pageName     STRING   
      );  
    ''');
  }

  static Future<List<String>> getList() async {
    final rawAllList = await db.query(_tableName);
    return rawAllList.map((item) => item['pageName']).cast<String>();
  }

  static Future<void> setList(List<String> watchList) async {
    await WatchListManagerDbClient.initialize();
    await Future.wait(
      watchList.map((item) => db.insert(_tableName, { 'pageName': item }))
    );
  }

  static Future<void> add(String pageName) async {
    await WatchListManagerDbClient.remove(pageName);
    await db.insert(_tableName, { 'pageName': pageName });
  }

  static Future<void> remove(String pageName) {
    return db.delete(_tableName, where: 'pageName = ?', whereArgs: [pageName]);
  }

  static Future<void> clear() {
    return db.delete(_tableName);
  }
}

