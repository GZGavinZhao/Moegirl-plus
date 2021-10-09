// @dart=2.9


import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:moegirl_plus/api/article.dart';
import 'package:moegirl_plus/database/reading_history.dart';
class ReadingHistoryManager {
  static Future<void> add(String pageName, [String displayPageName]) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final mainImage = await ArticleApi.getMainImage(pageName, 250)
      .catchError((e) {
        print('获取浏览历史配图失败');
        print(e);
        return null;
      });

    var readingHistory = ReadingHistory(
      pageName: pageName,
      displayPageName: displayPageName,
      timestamp: timestamp,
      image: null,
    ); 

    if (mainImage != null) {
      try {
        final Response<Uint8List> res = await Dio().get(mainImage['source'], options: Options(responseType: ResponseType.bytes));
        readingHistory.image = res.data;
      } catch(e) {
        print('下载浏览历史配图失败');
        print(e);
      }
    }

    await ReadingHistoryDbClient.add(readingHistory);
  }

  static Future<List<ReadingHistory>> getList() async {
    return ReadingHistoryDbClient.getList();
  }

  static Future<void> clear() async {
    await ReadingHistoryDbClient.clear(); 
  }
}