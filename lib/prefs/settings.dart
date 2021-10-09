// @dart=2.9
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';

class SettingsPref extends PrefManager {
  final prefStorage = PrefStorage.settings;

  bool get heimu => getPref('heimu', true);
  bool get stopAudioOnLeave => getPref('stopAudioOnLeave', true);
  bool get cachePriority => getPref('cachePriority', false);
  String get source => getPref('source', 'moegirl');  // 这个属性暂时废弃了
  String get theme => getPref('theme', RuntimeConstants.source == 'moegirl' ? 'green' : 'orange');
  String get lang => getPref('lang', 'zh-hans');

  set heimu(bool value) => setPref('heimu', value);
  set stopAudioOnLeave(bool value) => setPref('stopAudioOnLeave', value);
  set cachePriority(bool value) => setPref('cachePriority', value);
  set source(String value) => setPref('source', value);
  set theme(String value) => setPref('theme', value);
  set lang(String value) => setPref('lang', value);
}