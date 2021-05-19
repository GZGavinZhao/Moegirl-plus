import 'package:moegirl_plus/api/watch_list.dart';
import 'package:moegirl_plus/database/index.dart';
import 'package:moegirl_plus/database/watch_list.dart';

class WatchListManager {
  static Future<List<String>> getList() {
    return WatchListManagerDbClient.getList();
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
      await WatchListManagerDbClient.setList(resultList);
      return true;
    } else {
      return false;
    }
  }

  static Future<void> clear() {
    return WatchListManagerDbClient.initialize();
  }

  static add(String pageName) async {
    final currentList = await getList();
    final existsIndex = currentList.indexWhere((item) => item == pageName);
    if (existsIndex != -1) currentList.removeAt(existsIndex);

    await WatchListManagerDbClient.add(pageName);
  }

  static delete(String pageName) async {
    final currentList = await getList();
    currentList.removeWhere((item) => item == pageName);
    await WatchListManagerDbClient.remove(pageName);
  }
}