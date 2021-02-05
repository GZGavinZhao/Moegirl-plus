import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/database/category_search_history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum MyDatabases {
  categorySearchHistory
}

Database db;

final Future<void> databaseReady = Future(() async {
  db = await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: _initializeDatabase,
    version: databaseVersion
  );
});

void _initializeDatabase(Database db, int version) {
  CategorySearchHistoryManager.initialize(db);
}