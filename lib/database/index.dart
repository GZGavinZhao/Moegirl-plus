import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/database/category_search_history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

final Future<void> databaseReady = Future(() async {
  db = await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: _initializeDatabase,
    version: databaseVersion
  );
});

Future<List<String>> getDatabaseTables(Database db) async {
  final rawList = await db.query('sqlite_master', columns: ['name'], where: 'type = ?', whereArgs: ['table']);
  return rawList.map((item) => item['name']).cast<String>().toList();
}

Future<bool> hasDatabaseTable(Database db, String tableName) async {
  return getDatabaseTables(db).then((tables) => tables.contains(tableName));
}

void _initializeDatabase(Database db, int version) {
  CategorySearchHistoryManager.initialize(db);
}