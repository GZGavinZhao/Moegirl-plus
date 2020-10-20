import 'package:mobx/mobx.dart';
import 'package:moegirl_viewer/prefs/index.dart';

part 'index.g.dart';
 
class SettingsStore = _SettingsBase with _$SettingsStore;

abstract class _SettingsBase with Store {
  @observable Map<String, dynamic> _data = {
    'heimu': settingsPref.heimu,
    'stopAudioOnLeave': settingsPref.stopAudioOnLeave,
    'cachePriority': settingsPref.cachePriority,
    'source': settingsPref.source,
    'theme': settingsPref.theme,
    'lang': settingsPref.lang
  };

  @computed bool get heimu => _data['heimu'];
  @computed bool get stopAudioOnLeave => _data['stopAudioOnLeave'];
  @computed bool get cachePriority => _data['cachePriority'];
  @computed String get source => _data['source'];
  @computed String get theme => _data['theme'];
  @computed String get lang => _data['lang'];

  @action
  Future<bool> setItem(String key, dynamic value) {
    _data[key] = value;
    return settingsPref.setPref(key, value);
  }
}