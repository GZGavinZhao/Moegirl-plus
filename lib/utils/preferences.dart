import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences pref;
final Future<SharedPreferences> prefReady = Future(() async {
  pref = await SharedPreferences.getInstance();
  return pref;
});

