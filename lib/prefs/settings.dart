import 'package:moegirl_viewer/prefs/index.dart';

class SettingsPref extends PrefManager {
  final prefStorage = PrefStorage.settings;

  Map<String, dynamic> _data = {
    'heimu': false,
    'stopAudioOnLeave': false,
    'cachePriority': false,
    'source': 'moegirl',
    'theme': 'green',
    'lang': 'zh-hans'
  };

  bool get heimu => getPref('heimu', true);
  bool get stopAudioOnLeave => getPref('stopAudioOnLeave', true);
  bool get cachePriority => getPref('cachePriority', false);
  String get source => getPref('source', 'moegirl');
  String get theme => getPref('theme', 'green');
  String get lang => getPref('lang', 'zh-hans');

  set heimu(bool value) => setPref('heimu', value);
  set stopAudioOnLeave(bool value) => setPref('stopAudioOnLeave', value);
  set cachePriority(bool value) => setPref('cachePriority', value);
  set source(String value) => setPref('source', value);
  set theme(String value) => setPref('theme', value);
  set lang(String value) => setPref('lang', value);
}