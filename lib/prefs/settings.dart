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

  bool get heimu => getItem('heimu', true);
  bool get stopAudioOnLeave => getItem('stopAudioOnLeave', true);
  bool get cachePriority => getItem('cachePriority', false);
  String get source => getItem('source', 'moegirl');
  String get theme => getItem('theme', 'green');
  String get lang => getItem('lang', 'zh-hans');

  set heimu(bool value) => setItem('heimu', value);
  set stopAudioOnLeave(bool value) => setItem('stopAudioOnLeave', value);
  set cachePriority(bool value) => setItem('cachePriority', value);
  set source(String value) => setItem('source', value);
  set theme(String value) => setItem('theme', value);
  set lang(String value) => setItem('lang', value);
}