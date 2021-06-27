import 'dart:convert';

import 'package:flutter/material.dart';

import 'index.dart';

final _tableName = getDatabaseName(MyDatabaseTable.backup);

class BackupDbClient {
  static Future<void> initialize() async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id              INTEGER    PRIMARY KEY    AUTOINCREMENT,
        type            TEXT,      -- 缓存类型
        contentIndex    TEXT,      -- 索引，同一种类型下的数据索引唯一
        content         TEXT,      -- 备份内容
        extra           TEXT       -- 额外数据，区别于备份内容，可以存储一些诸如日期等其他数据
      );  
    ''');
  }

  static Future<void> set(BackupType type, String index, String content, { 
    Map<String, dynamic> extra 
  }) async {
    final typeStr = _getBackupTypeName(type);
    final data = {
      'type': typeStr,
      'contentIndex': index,
      'content': content,
      'extra': jsonEncode(extra)
    };

    final updatedTotal = await db.update(_tableName, data,
      where: 'type = ? AND contentIndex = ?',
      whereArgs: [typeStr, index]
    );

    if (updatedTotal == 0) {
      await db.insert(_tableName, data);
    }
  }

  static Future<BackupData> get(BackupType type, String index) async {
    final result = await db.query(_tableName,
      where: 'type = ? AND contentIndex = ?',
      whereArgs: [_getBackupTypeName(type), index],
      limit: 1
    );

    return result.length == 1 ? BackupData.fromMap(result[0]) : null;
  }

  static Future<void> delete(BackupType type, String index) {
    return db.delete(_tableName, where: 'type = ? AND contentIndex = ?', whereArgs: [_getBackupTypeName(type), index]);
  }
 
  static Future<void> clear() {
    return db.delete(_tableName);
  }
}

enum BackupType {
  edit, comment
}

String _getBackupTypeName(BackupType type) => type.toString().split('.')[1];

class BackupData {
  BackupType type;
  String contentIndex;
  String content;
  Map<String, dynamic> extra;
  
  BackupData({
    this.type,
    this.contentIndex,
    @required this.content,
    this.extra
  });

  BackupData.fromMap(Map map) {
    this.type = BackupType.values.firstWhere((item) => _getBackupTypeName(item) == map['type']);
    this.contentIndex = map['contentIndex'];
    this.content = map['content'];
    this.extra = jsonDecode(map['extra']);
  }
}