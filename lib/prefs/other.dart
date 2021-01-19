import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/views/recent_changes/utils/show_options_dialog.dart';

// 这里存放一些零碎的pref
class OtherPref extends PrefManager {
  final prefStorage = PrefStorage.other;

  // 最后一次使用的非黑夜模式的主题，用于在抽屉上的普通与黑夜主题的互换按钮
  String get lastTheme => getPref('lastTheme');
  set lastTheme(String value) => setPref('lastTheme', value);

  // 最近修改的列表选项
  RecentChangesOptions get recentChangesOptions => 
    getPref('recentChangesOptions') != null ? 
      RecentChangesOptions.fromMap(getPref('recentChangesOptions')) : 
      RecentChangesOptions()
  ;
  set recentChangesOptions(RecentChangesOptions value) => setPref('recentChangesOptions', value.toMap());

  // 当用户点击了不再提示当前版本的更新时，记录这个版本号用于对比
  String get refusedVersion => getPref('refusedVersion');
  set refusedVersion(String value) => setPref('refusedVersion', value);
}