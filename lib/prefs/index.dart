import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moegirl_plus/prefs/account.dart';
import 'package:moegirl_plus/prefs/other.dart';
import 'package:moegirl_plus/prefs/search.dart';
import 'package:moegirl_plus/prefs/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

SearchingHistoryPref searchingHistoryPref;
SettingsPref settingsPref;
AccountPref accountPref;
OtherPref otherPref;

enum PrefStorage {
  searchingHistory,
  settings,
  account,
  other
}

SharedPreferences _pref;

final Future<void> prefReady = Future(() async {
  _pref = await SharedPreferences.getInstance();
  searchingHistoryPref = SearchingHistoryPref();
  settingsPref = SettingsPref();
  accountPref = AccountPref();
  otherPref = OtherPref();
});

abstract class PrefManager {
  /// 命名空间，在[PrefStorage]中声明，所有继承自prefManager的值都要设置这个值
  /// 该值会在真正设置pref时作为_data的名称
  @protected
  PrefStorage get prefStorage;
  /// 存储实际的pref数据，最终会被编码为json
  Map<String, dynamic> _data;
  
  PrefManager() {
    final dataJson = _pref.getString(prefStorage.toString());
    _data = dataJson != null ? jsonDecode(dataJson) : {};
  }

  Future<bool> _updatePref() async {
    final json = await Future.microtask(() => jsonEncode(_data));
    return _pref.setString(prefStorage.toString(), json);
  }

  @protected
  dynamic getPref(String key, [dynamic settingValueIfNotExist]) {
    if (settingValueIfNotExist != null && !_data.containsKey(key)) setPref(key, settingValueIfNotExist);
    return _data[key];
  }

  @protected
  Future<bool> setPref(String key, dynamic value) {
    _data[key] = value;
    return _updatePref();
  }

  @protected
  Future<bool> removePref(String key) {
    _data.remove(key);
    return _updatePref();
  }
}