import 'package:flutter/material.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class SettingsProviderModel with ChangeNotifier {
  Map<String, dynamic> _data = {
    'heimu': settingsPref.heimu,
    'stopAudioOnLeave': settingsPref.stopAudioOnLeave,
    'cachePriority': settingsPref.cachePriority,
    'source': settingsPref.source,
    'theme': settingsPref.theme,
    'lang': settingsPref.lang
  };

  bool get heimu => _data['heimu'];
  bool get stopAudioOnLeave => _data['stopAudioOnLeave'];
  bool get cachePriority => _data['cachePriority'];
  String get source => _data['source'];
  String get theme => _data['theme'];
  String get lang => _data['lang'];

  void _setItem(String name, dynamic value) {
    _data[name] = value;
    notifyListeners();
    settingsPref.setPref(name, value);
  }

  set heimu(bool value) => _setItem('heimu', value);
  set stopAudioOnLeave(bool value) => _setItem('stopAudioOnLeave', value);
  set cachePriority(bool value) => _setItem('cachePriority', value);
  set source(String value) => _setItem('source', value);
  set theme(String value) => _setItem('theme', value);
  set lang(String value) => _setItem('lang', value);
}

final settingsProvider = Provider.of<SettingsProviderModel>(OneContext().context, listen: false);