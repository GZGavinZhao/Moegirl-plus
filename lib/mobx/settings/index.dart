import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:moegirl_viewer/utils/preferences.dart';

part 'index.g.dart';
 
class SettingsStore = _SettingsBase with _$SettingsStore;

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
    (() async {
      final pref = await prefReady;
      _data.forEach((key, value) {
        _data[key] = pref.containsKey(key) ? jsonDecode(pref.getString(key)) : value;
      });
    })();
  }

  @action
  set(String key, dynamic value) {
    _data[key] = value;
    pref.setString(key, jsonEncode(value));
  }
}