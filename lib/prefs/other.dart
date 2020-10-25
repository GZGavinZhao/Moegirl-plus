import 'package:moegirl_viewer/prefs/index.dart';

class OtherPref extends PrefManager {
  final prefStorage = PrefStorage.other;

  // 最后一次使用的非黑夜模式的主题，用于在抽屉上的普通与黑夜主题的互换按钮
  String get lastTheme => getPref('lastTheme');
  set lastTheme(String value) => setPref('lastTheme', value);
}