import 'package:moegirl_plus/prefs/index.dart';

class AccountPref extends PrefManager {
  final prefStorage = PrefStorage.account;

  get userName => getPref('userName');
  set userName(String value) => setPref('userName', value);
}