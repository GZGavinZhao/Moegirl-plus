// @dart=2.9
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';

class ArticleApi {
  // 将多语言的页面名转换为真实页面名
  static Future<String> getTruePageName(String pageName) async {
    final data = await moeRequest(params: {
      'action': 'query',
      'titles': pageName,
      'converttitles': 1,
    });

    return data['query']['pages'].values.first['title'];
  }
    
  static Future<dynamic> articleDetail({ String pageName, int revId }) async {
    return moeRequest(params: {
      'action': 'parse',
      ...(pageName != null ? { 'page': pageName } : {}),
      'redirects': 1, 
      ...(revId != null ? { 'oldid': revId } : {}),
      'prop': 'text|categories|templates|sections|images|displaytitle'
    });
  }

  static Future<Map> getMainImage(String pageName, [int size = 500]) async {
    return moeRequest(params: {
      'action': 'query',
      'prop': 'pageimages',
      'titles': pageName,
      'pithumbsize': size
    })
      .then((data) => data['query']['pages'].values.toList()[0]['thumbnail']);
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
        baseUrl: RuntimeConstants.source == 'moegirl' ? 'https://commons.moegirl.org.cn/api.php' : apiUrlHmoe,
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
        .expand((item) => item['query'] != null ? item['query']['pages'].values : [])
        .toList()
        .asMap()
        .map((key, value) => MapEntry(
          value['title'].replaceFirst('File:', '').replaceFirst('文件:', ''), 
          value['imageinfo'][0]['url']
        ))
      );
  }

  static Future getPageInfo(String pageName) async {
    return moeRequest(
      params: {
        'action': 'query',
        'prop': 'info',
        'titles': pageName,
        'inprop': 'protection|watched|talkid',
      }
    )
      .then((data) => data['query']['pages'].values.toList()[0]);
  }
}