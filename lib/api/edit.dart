// @dart=2.9
import 'package:flutter/material.dart';
import 'package:moegirl_plus/request/moe_request.dart';

class EditApi {
  static Future getWikiCodes(String pageName, [String section]) async {
    return moeRequest(
      params: {
        'action': 'parse',
        'page': pageName,
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

  static Future<String> getLastTimestamp(String pageName) async {
    return moeRequest(
      params: {
        'action': 'query',
        'prop': 'revisions',
        'titles': pageName,
        'rvprop': 'timestamp',
        'rvlimit': 1
      }
    )
      .then((data) {
        String timestamp;

        // 尝试获取不存在的页面的时间戳数据，里面没有revisions字段
        if (data['query']['pages'].values.first['revisions'] != null) {
          timestamp = data['query']['pages'].values.first['revisions'][0]['timestamp'];
        }

        return timestamp;
      });
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
    String section,
    String content,
    @required String summary,
    @required String timestamp,
    int undoRevId,
    String captchaId,
    String captchaWord
  }) async {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'edit',
        'tags': 'Android App Edit',
        'minor': 1,
        'title': pageName,
        ...(content != null ? { 'text': content } : {}),
        'summary': summary,
        'token': token,
        ...(section != null ? { 'section': section } : {}),
        ...(timestamp != null ? { 'basetimestamp': timestamp } : {}),
        ...(captchaId != null ? { 'captchaid': captchaId } : {}),
        ...(captchaWord != null ? { 'captchaword': captchaWord } : {}),
        ...(undoRevId != null ? { 'undo': undoRevId } : {})
      }
    );
  }

  static Future<void> editArticle({
    @required String pageName,
    String section,
    String content,
    @required String summary,
    int undoRevId, // 传入该参数时，会执行撤销

    String captchaId, // 无用参数，萌百已经不用验证码了，这里还暂时保留
    String captchaWord,
    bool retry = true // 发生错误时尝试再次提交，用来跳过警告
  }) async {
    final timestamp = await getLastTimestamp(pageName);
    final token = (await getCsrfToken())['query']['tokens']['csrftoken'];

    try {
      await _executeEditArticle(
        token: token, 
        pageName: pageName, 
        section: section, 
        content: content, 
        summary: summary, 
        timestamp: timestamp,
        undoRevId: undoRevId,
        captchaId: captchaId,
        captchaWord: captchaWord
      );
    } catch(e) {
      if (retry) {
        return editArticle(
          pageName: pageName, 
          section: section, 
          content: content, 
          summary: summary,
          undoRevId: undoRevId,
          captchaId: captchaId,
          captchaWord: captchaWord,
          retry: false
        );
      } else {
        if (e is MoeRequestError) {
          throw e.code;
        } else {
          rethrow;
        }
      }
    }
  }
}