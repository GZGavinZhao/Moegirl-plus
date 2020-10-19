import 'dart:convert';

import 'package:moegirl_viewer/prefs/account.dart';
import 'package:moegirl_viewer/prefs/search.dart';
import 'package:moegirl_viewer/prefs/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences pref;
SearchingHistoryPref searchingHistoryPref;
SettingsPref settingsPref;
AccountPref accountPref;

enum PrefStorage {
  searchingHistory,
  settings,
  account
}

final Future<void> prefReady = Future(() async {
  pref = await SharedPreferences.getInstance();
  searchingHistoryPref = SearchingHistoryPref();
  settingsPref = SettingsPref();
  accountPref = AccountPref();
});

abstract class PrefManager {
  PrefStorage get prefStorage;
  Map<String, dynamic> _data;
  
  PrefManager() {
    final dataJson = pref.getString(prefStorage.toString());
    _data = dataJson != null ? jsonDecode(dataJson) : {};
  }

  Future<bool> _updatePref() => pref.setString(prefStorage.toString(), jsonEncode(_data));

  T getItem<T>(String key, [dynamic settingValueIfNotExist]) {
    if (settingValueIfNotExist != null && !_data.containsKey(key)) _data[key] = settingValueIfNotExist;
    return _data[key];
  }

  Future<bool> setItem(String key, dynamic value) {
    _data[key] = value;
    return _updatePref();
  }

  Future<bool> removeItem(String key) {
    _data.remove(key);
    return _updatePref();
  }
}