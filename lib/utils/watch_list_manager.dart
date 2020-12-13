import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

const _rootDirName = 'watch_list';
const _dataFileName = 'data.json';

class WatchListManager {
  static List<String> _list = [];
  static num loadingStatus = 1;

  static Future<List<String>> getList() {

  } 

  static Future<void> loadList() {

  }

  static Future<void> loadFullList() {

  }

  static Future<void> clear() {

  }
}

Future<String> _basePath() async {
  final docPath = (await getApplicationDocumentsDirectory()).path;
  return p.join(docPath, _rootDirName);
}

Future<File> _getDataFile() async {
  final dataFilePath = p.join(await _basePath(), _dataFileName);
  final dataFile = File(dataFilePath);
  final dataFileStat = await dataFile.stat();
  if (dataFileStat.type == FileSystemEntityType.notFound) {
    await dataFile.create(recursive: true);
    await dataFile.writeAsString('[]');
  }

  return dataFile;
}