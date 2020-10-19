import 'package:moegirl_viewer/mobx/account/index.dart';
import 'package:moegirl_viewer/mobx/comment/index.dart';
import 'package:moegirl_viewer/mobx/settings/index.dart';
import 'package:moegirl_viewer/prefs/index.dart';

SettingsStore settingsStore;
AccountStore accountStore;
CommentStore commentStore;

final Future<void> mobxReady = Future(() async {
  await prefReady;
  settingsStore = SettingsStore();
  accountStore = AccountStore();
  commentStore = CommentStore();
});
