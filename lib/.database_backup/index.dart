// @dart=2.9
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/database/backup/index.dart';
import 'package:moegirl_plus/database/category_search_history/index.dart';
import 'package:moegirl_plus/database/reading_history/index.dart';
import 'package:moegirl_plus/database/watch_list/index.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

enum MyDatabaseTable {
  categorySearchHistory, readingHistory, watchList, backup
}
class DatabasePatch {
  final int version;
  final Future<void> Function(Database db, String tableName, int oldVersion, int newVersion) handle;

  DatabasePatch(this.version, this.handle);
}

final Map<MyDatabaseTable, List<DatabasePatch>> databasePatches = {
  MyDatabaseTable.backup: []
};

String getDatabaseName(MyDatabaseTable myDatabaseTable) {
  return myDatabaseTable.toString().split('.')[1];
}

final Future<void> databaseReady = Future(() async {
  db = await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: _initializeDatabase,
    onUpgrade: _upgradeDatabase,
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

// 触发数据库版本更新时，判断版本执行补丁
Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
  Future<void> execPatchHandle(tableName, List<DatabasePatch> patches) async {
    final newPatches = patches.where((element) => element.version > oldVersion);
    for (var patch in newPatches) {
      await patch.handle(db, tableName, oldVersion, newVersion);
    }
  }

  await Future.wait([
    execPatchHandle(getDatabaseName(MyDatabaseTable.categorySearchHistory), CategorySearchHistoryDbClient.patches),
    execPatchHandle(getDatabaseName(MyDatabaseTable.readingHistory), ReadingHistoryDbClient.patches),
    execPatchHandle(getDatabaseName(MyDatabaseTable.watchList), WatchListManagerDbClient.patches),
    execPatchHandle(getDatabaseName(MyDatabaseTable.backup), BackupDbClient.patches)
  ]);
}

// 初始化表
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