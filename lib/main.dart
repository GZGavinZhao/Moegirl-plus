import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moegirl_plus/app_init.dart';
import 'package:moegirl_plus/database/index.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/comment.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/routes/router.dart';
import 'package:moegirl_plus/themes.dart';
import 'package:moegirl_plus/utils/provider_change_checker.dart';
import 'package:moegirl_plus/utils/ui/set_status_bar.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import 'utils/route_aware.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 等待必要数据加载完毕，注意避免出现数据互相等待的情况
  await Future.wait([
    prefReady,
    moeRequestReady,
    databaseReady,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountProviderModel>(create: (_) => AccountProviderModel()),
        ChangeNotifierProvider<SettingsProviderModel>(create: (_) => SettingsProviderModel()),
        ChangeNotifierProvider<CommentProviderModel>(create: (_) => CommentProviderModel())
      ],
      child: MyApp()
    )
  );

  setStatusBarColor(Colors.transparent);
}


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with 
  AfterLayoutMixin, 
  ProviderChangeChecker,
  AppInit
{
  @override
  Widget build(BuildContext context) {    
    return Selector<SettingsProviderModel, String>(
      selector: (_, provider) => provider.theme,
      builder: (context, theme, __) => (
        MaterialApp(
          title: 'Moegirl+',
          theme: themes[theme],
          onGenerateRoute: router.generator,
          navigatorObservers: [routeObserver, HeroController()],
          builder: OneContext().builder,
          navigatorKey: OneContext().key,

          locale: context.select<SettingsProviderModel, Locale>((provider) => provider.locale),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('zh', 'Hans'),
            Locale('zh', 'Hant')
          ],
        )
      )
    );
  }
}


