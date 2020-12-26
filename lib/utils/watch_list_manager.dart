import 'dart:convert';
import 'dart:io';

import 'package:moegirl_plus/api/watch_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

const _rootDirName = 'watch_list';
const _dataFileName = 'data.json';

class WatchListManager {
  static List<String> _list;
  static num loadingStatus = 1;

  static Future<List<String>> getList() async {
    final dataFile = await _getDataFile();
    if (_list == null) _list = jsonDecode(await dataFile.readAsString()).cast<String>();
    return _list;
  } 

  static Future<bool> refreshList() async {
    String continueKey;
    int retryFlag = 0;  // 0~3：失败重试第0次到第三次；4：失败4次，退出循环；5：全部加载完成
    List<String> resultList = [];
    
    Future<void> loadList() async {
      final data = await WatchListApi.getRawWatchList(continueKey);
      continueKey = data['continue'] != null ? data['continue']['wrcontinue'] : null;
      resultList.addAll(data['watchlistraw'].map((item) => item['title']).cast<String>());
    }

    while (retryFlag < 4) {
      try {
        if ([1, 2, 3].contains(retryFlag)) print('加载原始监视列表失败，重试第$retryFlag次');
        await loadList();
        retryFlag = 0;
        if (continueKey == null) retryFlag = 5;
      } catch(e) {
        retryFlag++;
        print(e);
      }
    }

    if (retryFlag == 5) {
      _list = resultList;
      final dataFile = await _getDataFile();
      dataFile.writeAsString(jsonEncode(resultList));
      return true;
    } else {
      return false;
    }
  }

  static Future<void> clear() async {
    _list.clear();
    final dataFile = await _getDataFile();
    dataFile.writeAsString('[]');
  }

  static add(String pageName) async {
    final currentList = await getList();
    final existsIndex = currentList.indexWhere((item) => item == pageName);
    if (existsIndex != -1) currentList.removeAt(existsIndex);

    _list = [pageName, ...currentList];
    final dataFile = await _getDataFile();
    dataFile.writeAsString(jsonEncode(_list));
  }

  static delete(String pageName) async {
    final currentList = await getList();
    currentList.removeWhere((item) => item == pageName);
    
    _list = currentList;
    final dataFile = await _getDataFile();
    dataFile.writeAsString(jsonEncode(currentList));
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