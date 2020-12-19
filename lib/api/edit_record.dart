// 包括和最近更改，编辑历史，差异对比的相关api

import 'package:flutter/cupertino.dart';
import 'package:moegirl_viewer/request/moe_request.dart';

class EditRecordApi {
  static Future getRecentChanges({
    String startISO,
    String namespace,
    String excludeUser,
    bool includeMinor,
    bool includeRobot,
    int limit
  }) {
    final List<String> showing = [];
    if (!includeMinor) showing.add('!minor');
    if (!includeRobot) showing.add('!bot');

    return moeRequest(
      params: {
        'action': 'query',
        'list': 'recentchanges',
        'rcend': startISO,
        'rcnamespace': namespace,
        ...(excludeUser != null ? { 'rcexcludeuser': excludeUser } : {}),
        'rcprop': 'tags|comment|flags|user|title|timestamp|ids|sizes|redirect',
        'rcshow': showing.join('|'),
        'rclimit': limit
      }
    )
      .then((data) => data['query']['recentchanges']);
  }

  static Future getWatchingPageChanges() {
    return moeRequest(
      params: {
        'action': 'query',
        'format': 'json',
        'list': 'watchlist',
        'wllimit': '500',
        'wlprop': 'title'
      }
    );
  }

  static Future compurePage({
    @required String fromTitle,
    @required int fromRev,
    @required String toTitle,
    @required int toRev,
  }) {
    return moeRequest(
      params: {
        'action': 'compare',
        'format': 'json',
        'fromtitle': fromTitle,
        ...(fromRev != null ? { 'fromrev': fromRev } : {}),
        'totitle': toTitle,
        ...(toRev != null ? { 'torev': toRev } : {}),
        'prop': 'diff|diffsize|rel|user|comment',
      }
    );
  }
}