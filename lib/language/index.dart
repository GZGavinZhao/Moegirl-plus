import 'package:moegirl_plus/language/zh_hans.dart';
import 'package:moegirl_plus/language/zh_hant.dart';
import 'package:moegirl_plus/providers/settings.dart';

final Language_zh_Hans Lang = (() {
  final zhHans = Language_zh_Hans();
  final zhHant = Language_zh_Hant();
  final usingLanguage = settingsProvider.lang.toLowerCase();
  
  return {
    'zh-hans': zhHans,
    'zh-hant': zhHant
  }[usingLanguage];
})();
