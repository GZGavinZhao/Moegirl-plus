import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:moegirl_viewer/utils/preferences.dart';

part 'index.g.dart';
 
class SettingsStore = _SettingsBase with _$SettingsStore;

const prefKeyPrefix = 'settings:';

abstract class _SettingsBase with Store {
  @observable Map<String, dynamic> _data = {
    'heimu': false,
    'stopAudioOnLeave': false,
    'cachePriority': false,
    'source': 'moegirl',
    'theme': 'green',
    'lang': 'zh-hans'
  };

  @computed bool get heimu => _data['heimu'];
  @computed bool get stopAudioOnLeave => _data['stopAudioOnLeave'];
  @computed bool get cachePriority => _data['cachePriority'];
  @computed String get source => _data['source'];
  @computed String get theme => _data['theme'];
  @computed String get lang => _data['lang'];

  _SettingsBase() {
    var currentData = <String, dynamic>{};

    _data.forEach((key, value) {
      key = prefKeyPrefix + key;
      currentData[key] = pref.containsKey(key) ? jsonDecode(pref.getString(key)) : value;
    });

    _data = currentData;
  }

  @action
  set(String key, dynamic value) {
    key = prefKeyPrefix + key;
    _data[key] = value;
    pref.setString(key, jsonEncode(value));
  }
}