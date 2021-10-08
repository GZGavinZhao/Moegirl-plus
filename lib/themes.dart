import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';

const nightPrimaryColor = Color(0xff3A3A3B);

ThemeData _withCommonTheme(ThemeData themeData, [bool night = false]) {
  final colorScheme = themeData.colorScheme.copyWith(
    onPrimary: night ? Color(0xffBFBFBF) : Colors.white,
    surface: night ? nightPrimaryColor : Colors.white,
  );

  final textTheme = themeData.textTheme
      .apply(
          bodyColor: Color(night ? 0xffBFBFBF : 0xff323232),
          displayColor: Color(night ? 0xffBFBFBF : 0xff323232))
      .copyWith(
        button: TextStyle(color: themeData.primaryColor),
      );

  return themeData.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    splashFactory: InkRipple.splashFactory,
    brightness: themeData.brightness ?? Brightness.light,
    backgroundColor: night ? Color(0xff252526) : Colors.white,
    cardColor: colorScheme.surface,
    colorScheme: colorScheme,
    appBarTheme: themeData.appBarTheme.copyWith(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light)),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: themeData.primaryColorLight,
      cursorColor: themeData.colorScheme.secondary,
      selectionHandleColor: themeData.colorScheme.secondary,
    ),
    textTheme: textTheme,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                themeData.colorScheme.secondary.withOpacity(0.2)),
            foregroundColor:
                MaterialStateProperty.all(themeData.colorScheme.secondary))),
  );
}

ThemeData _theme(MaterialColor color) =>
    _withCommonTheme(ThemeData(primarySwatch: color));

final nightTheme = _withCommonTheme(
    ThemeData(
        primaryColor: nightPrimaryColor,
        primaryColorDark: RuntimeConstants.source == 'moegirl'
            ? Color(0xff076642)
            : Color(0xffB9D5BA),
        primaryColorLight: RuntimeConstants.source == 'moegirl'
            ? Color(0xff0B9560)
            : Color(0xffC9E7CA),
        scaffoldBackgroundColor: Color(0xff252526),
        dividerColor: Color(0xff626262),
        hintColor: Color(0xffD0D0D0),
        disabledColor: Color(0xff797979),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: RuntimeConstants.source == 'moegirl'
                ? Color(0xff0DBC79)
                : Color(0xffFFE686))),
    true);

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
