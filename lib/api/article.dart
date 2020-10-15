import 'package:moegirl_viewer/request/moe_request.dart';

class ArticleApi {
  static Future<String> translatePageName(String pageName) async {
    try {
      final data = await moeRequest(params: {
        'action': 'query',
        'format': 'json',
        'titles': pageName,
        'converttitles': 1,
      });

      return data['query']['pages'].values.first['title'];
    } catch(e) {
      print('请求标题转换失败');
      print(e);
      return pageName;
    }
  }
    
  static Future articleDetail(String pageName) async {
    final translatedPageName = await translatePageName(pageName);
    return moeRequest(params: {
      'action': 'parse',
      'page': translatedPageName,
      'redirects': 1,
      'prop': 'text|categories|templates|sections|images|displaytitle'
    });
  }

  static Future getMainPage(String pageName, [int size = 500]) async {
    final translatedTitle = await translatePageName(pageName);
    return moeRequest(params: {
      'action': 'query',
      'prop': 'pageimages',
      'titles': translatedTitle,
      'pithumbsize': size
    })
      .then((data) => data['query']['pages'].values[0]['thumbnail']);
  }

  static Future<Map<String, String>> getImagesUrl(List<String> imageNames) {
    final requestFragments = [<String>[]];
    imageNames.forEach((item) {
      if (requestFragments.last.length == 50) {
        requestFragments.add([item]);
      } else {
        requestFragments.last.add(item);
      }
    });

    return Future.wait(
      requestFragments.map((imageNamesFragment) => moeRequest(
        baseUrl: 'https://commons.moegirl.org.cn/api.php',
        method: 'post',
        params: {
          'action': 'query',
          'prop': 'imageinfo',
          'titles': imageNamesFragment.map((item) => 'File:' + item).join('|'),
          'iiprop': 'url'
        }
      ))
    )
      .then((res) => res
        .expand((item) => item['query']['pages'].values)
        .toList()
        .asMap()
        .map((key, value) => MapEntry(
          value['title'].replaceFirst('File:', ''), 
          value['imageinfo'][0]['url']
        ))
      );
  }
}