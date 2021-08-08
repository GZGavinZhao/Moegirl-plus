import 'package:moegirl_plus/database/index.dart';

final readingHistoryDbPatchV2 = DatabasePatch(2, (db, tableName, oldVersion, newVersion) async {
  await db.execute('''
    ALTER TABLE $tableName ADD COLUMN source TEXT;
  ''');
  await db.update(tableName, { 'source': 'moegirl' });
});