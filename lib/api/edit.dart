import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/article.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/request/plain_request.dart';

class EditApi {
  static Future getWikiCodes(String pageName, [String section]) async {
    final translatedPageName = await ArticleApi.translatePageName(pageName);

    return moeRequest(
      params: {
        'action': 'parse',
        'page': translatedPageName,
        'prop': 'wikitext',
        ...(section != null ? { 'section': section } : {})
      }
    );
  }

  static Future getPreview(String wikiCodes, String pageName) {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'parse',
        'text': wikiCodes,
        'prop': 'text',
        'title': pageName,
        'preview': 1,
        'sectionpreview': 1,
        'contentmodel': 'wikitext'
      }
    );
  }

  static Future getLastTimestamp(String pageName) async {
    final translatedPageName = await ArticleApi.translatePageName(pageName);
    return moeRequest(
      params: {
        'action': 'query',
        'prop': 'revisions',
        'titles': translatedPageName,
        'rvprop': 'timestamp',
        'rvlimit': 1
      }
    );
  }

  static Future getCsrfToken() async {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'query',
        'meta': 'tokens'
      }
    );
  }

  static Future _executeEditArticle({
    @required String token,
    @required String pageName,
    @required String section,
    @required String content,
    @required String summary,
    @required String timestamp,
    String captchaId,
    String captchaWord
  }) async {
    final translatedPageName = await ArticleApi.translatePageName(pageName);
    return moeRequest(
      method: 'post',
      params: {
        'action': 'edit',
        'tags': 'Android App Edit',
        'minor': 1,
        'title': translatedPageName,
        'text': content,
        'summary': summary,
        'token': token,
        ...(section != null ? { 'section': section } : {}),
        ...(timestamp != null ? { 'basetimestamp': timestamp } : {}),
        ...(captchaId != null ? { 'captchaid': captchaId } : {}),
        ...(captchaWord != null ? { 'captchaword': captchaWord } : {}),
      }
    );
  }

  static Future<String> editArticle({
    @required String pageName,
    @required String section,
    @required String content,
    @required String summary,
    String captchaId,
    String captchaWord,
    bool retry = true
  }) async {
    final timestampData = await getLastTimestamp(pageName);
    String timestamp;

    // 尝试获取不存在的页面的时间戳数据，里面没有revisions字段
    if (timestampData['query']['pages'].values.first['revisions'] != null) {
      timestamp = timestampData['query']['pages'].values.first['revisions'][0]['timestamp'];
    }

    final token = (await getCsrfToken())['query']['tokens']['csrftoken'];

    final editedResult = await _executeEditArticle(
      token: token, 
      pageName: pageName, 
      section: section, 
      content: content, 
      summary: summary, 
      timestamp: timestamp,
      captchaId: captchaId,
      captchaWord: captchaWord
    );

    if (!editedResult.containsKey('error')) {
      if (retry) return editArticle(
        pageName: pageName, 
        section: section, 
        content: content, 
        summary: summary,
        captchaId: captchaId,
        captchaWord: captchaWord,
        retry: false
      );
    } else {
      return editedResult['error']['code'];
    }
  }

  static Future getCaptcha() async {
    final apiUrl = 'https://mmixlaxtpscprd.moegirlpedia.moetransit.com/questionEntry/BeginChallenge';
    final captchaBaseUrl = 'https://mmixlaxtpscprd.moegirlpedia.moetransit.com/image/Retrieval?id=';

    final resData = await baseRequest.request(apiUrl,
      queryParameters: { 'expectedLang': 'zh-CN' }
    );

    return {
      'data': resData.data,
      'path': captchaBaseUrl + resData.data['path']
    };
  }
}