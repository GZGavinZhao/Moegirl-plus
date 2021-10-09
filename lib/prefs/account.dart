// @dart=2.9
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';

class AccountPref extends PrefManager {
  final prefStorage = PrefStorage.account;

  get userName => getPref(RuntimeConstants.source + '-userName');
  set userName(String value) => setPref(RuntimeConstants.source + '-userName', value);
}