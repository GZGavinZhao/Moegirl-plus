import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/database/backup.dart';
import 'package:moegirl_plus/database/category_search_history.dart';
import 'package:moegirl_plus/database/reading_history.dart';
import 'package:moegirl_plus/database/watch_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

enum MyDatabaseTable {
  categorySearchHistory, readingHistory, watchList, backup
}

String getDatabaseName(MyDatabaseTable myDatabaseTable) {
  return myDatabaseTable.toString().split('.')[1];
}

final Future<void> databaseReady = Future(() async {
  db = await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: _initializeDatabase,
    version: databaseVersion
  );

  // 检查是否有不存在的表，有则创建
  await checkDataBaseTables();
});

Future<List<String>> getDatabaseTables() async {
  final rawList = await db.query('sqlite_master', columns: ['name'], where: 'type = ?', whereArgs: ['table']);
  return rawList.map((item) => item['name']).cast<String>().toList();
}

Future<bool> hasDatabaseTable(MyDatabaseTable myDatabaseTable) async {
  return getDatabaseTables().then((tables) => tables.contains(getDatabaseName(myDatabaseTable)));
}

void _initializeDatabase(Database database, int version) {
  db = database;
  CategorySearchHistoryDbClient.initialize();
  WatchListManagerDbClient.initialize();
  ReadingHistoryDbClient.initialize();
  BackupDbClient.initialize();
}

Future<void> checkDataBaseTables() async {
  final checkListMappedToInitializeFns = {
    MyDatabaseTable.categorySearchHistory: CategorySearchHistoryDbClient.initialize,
    MyDatabaseTable.readingHistory: ReadingHistoryDbClient.initialize,
    MyDatabaseTable.watchList: WatchListManagerDbClient.initialize,
    MyDatabaseTable.backup: BackupDbClient.initialize
  };
  
  return Future.wait(
    checkListMappedToInitializeFns.map((myDatabaseTable, initializeFn) => 
      MapEntry(myDatabaseTable, Future(() async {
        if (!await hasDatabaseTable(myDatabaseTable)) await initializeFn();
      }))
    ).values.toList()
  );
}