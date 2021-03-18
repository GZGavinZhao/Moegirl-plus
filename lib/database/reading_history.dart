import 'dart:typed_data';

import 'index.dart';

final _tableName = getDatabaseName(MyDatabaseTable.readingHistory);

class ReadingHistoryDbClient {
  static Future<void> initialize() async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id                INTEGER    PRIMARY KEY    AUTOINCREMENT,
        pageName          TEXT,
        displayPageName   TEXT,
        timestamp         DATETIME,
        image             BLOB
      );  
    ''');
  }

  static Future<List<ReadingHistory>> getList() async {
    final rawAllList = await db.query(_tableName);
    final List<ReadingHistory> resultList = [];

    // 这里不知道为什么rawAllList拿到的不是List，而是QueryResultSet，并且没有map方法，但实现了迭代器，只好用forin了
    for (var item in rawAllList) {
      resultList.add(ReadingHistory.fromMap(item));
    }

    return resultList;
  }

  static Future<void> add(ReadingHistory readingHistory) async {
    await ReadingHistoryDbClient.remove(readingHistory.pageName);
    db.insert(_tableName, readingHistory.toMap());
  }

  static Future<void> remove(String pageName) async {
    await db.delete(_tableName, where: 'pageName = ?', whereArgs: [pageName]);
  }

  static Future<void> clear() {
    return db.delete(_tableName);
  }
}

class ReadingHistory {
  String pageName;
  String displayPageName;
  int timestamp;
  Uint8List image;

  ReadingHistory({
    this.pageName,
    this.displayPageName,
    this.timestamp,
    this.image
  });

  ReadingHistory.fromMap(Map map) {
    pageName = map['pageName'];
    displayPageName = map['displayPageName'];
    timestamp = map['timestamp'];
    image = map['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'pageName': pageName,
      'displayPageName': displayPageName,
      'timestamp': timestamp,
      'image': image
    };
  }
}
