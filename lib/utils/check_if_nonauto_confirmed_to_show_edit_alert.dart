import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> checkIfNonautoConfirmedToShowEditAlert(String pageName, [String section]) async {
  final isAutoConfirmed = await accountProvider.inUserGroup(UserGroups.autoConfirmed);
  if (!isAutoConfirmed) {
    final result = await showAlert<bool>(
      content: Lang.nonAutoConfirmedHint,
      visibleCloseButton: true
    );

    if (result) {
      final sectionParam = section != null ? '&section=$section' : '';
      launch('https://mzh.moegirl.org.cn/index.php?title=$pageName&action=edit$sectionParam');
    }

    return true;
  }

  return false;
}