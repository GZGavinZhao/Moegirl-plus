import 'package:flutter/material.dart';

ThemeData _withCommonTheme(ThemeData themeData, [bool night = false]) {
  final colorScheme = ColorScheme.fromSwatch().copyWith(
    onPrimary: night ? Color(0xffBFBFBF) : Colors.white
  );

  final textTheme = themeData.textTheme.apply(
    bodyColor: Color(night ? 0xffBFBFBF : 0xff323232),
    displayColor: Color(night ? 0xffBFBFBF : 0xff323232)
  );
  
  return themeData.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    splashFactory: InkRipple.splashFactory,
    backgroundColor: night ? Color(0xff3A3A3B) : Colors.white,
    cursorColor: themeData.primaryColor,
    colorScheme: colorScheme,
    textTheme: textTheme
  );
}

ThemeData _theme(MaterialColor color) => _withCommonTheme(ThemeData(primarySwatch: color));

final nightTheme = _withCommonTheme(ThemeData(
  primaryColor: Color(0xff4E4E4E),
  accentColor: Color(0xff0DBC79),
  primaryColorDark: Color(0xff076642),
  primaryColorLight: Color(0xff0B9560),
  scaffoldBackgroundColor: Color(0xff3A3A3B),
  dividerColor: Color(0xff4E4E4E),
  hintColor: Color(0xffD0D0D0),
  disabledColor: Color(0xff797979),
), true);

final Map<String, ThemeData> themes = {
  'green': _theme(Colors.green),
  'pink': _theme(Colors.pink),
  'indigo': _theme(Colors.indigo),
  'orange': _theme(Colors.orange),
  'blue': _theme(Colors.blue),
  'deepPurple': _theme(Colors.deepPurple),
  'teal': _theme(Colors.teal),
  'night': nightTheme
};