import 'package:flutter/material.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class SettingsProviderModel with ChangeNotifier {
  bool get heimu => settingsPref.heimu;
  bool get stopAudioOnLeave => settingsPref.stopAudioOnLeave;
  bool get cachePriority => settingsPref.cachePriority;
  String get source => settingsPref.source;
  String get theme => settingsPref.theme;
  String get lang => settingsPref.lang;

  void _andthenNotifyListeners(Function fn) {
    fn();
    notifyListeners();
  }
  
  set heimu(bool value) => _andthenNotifyListeners(() => settingsPref.heimu = value);
  set stopAudioOnLeave(bool value) => _andthenNotifyListeners(() => settingsPref.stopAudioOnLeave = value);
  set cachePriority(bool value) => _andthenNotifyListeners(() => settingsPref.cachePriority = value);
  set source(String value) => _andthenNotifyListeners(() => settingsPref.source = value);
  set theme(String value) => _andthenNotifyListeners(() => settingsPref.theme = value);
  set lang(String value) => _andthenNotifyListeners(() => settingsPref.lang = value);
}

final settingsProvider = Provider.of<SettingsProviderModel>(OneContext().context, listen: false);