import 'package:moegirl_viewer/prefs/index.dart';

class AccountPref extends PrefManager {
  final prefStorage = PrefStorage.account;

  get userName => getItem('userName');
  set userName(String value) => setItem('userName', value);
}