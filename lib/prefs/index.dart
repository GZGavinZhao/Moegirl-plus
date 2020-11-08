import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/prefs/account.dart';
import 'package:moegirl_viewer/prefs/other.dart';
import 'package:moegirl_viewer/prefs/search.dart';
import 'package:moegirl_viewer/prefs/settings.dart';
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
  PrefStorage get prefStorage;
  Map<String, dynamic> _data;
  
  PrefManager() {
    final dataJson = _pref.getString(prefStorage.toString());
    _data = dataJson != null ? jsonDecode(dataJson) : {};
  }

  Future<bool> _updatePref() => _pref.setString(prefStorage.toString(), jsonEncode(_data));

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