import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moegirl_plus/app_init.dart';
import 'package:moegirl_plus/database/index.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/comment.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/routes/router.dart' hide Route;
import 'package:moegirl_plus/themes.dart';
import 'package:moegirl_plus/utils/is_prod.dart';
import 'package:moegirl_plus/utils/provider_change_checker.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/utils/setRootBrightness.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:one_context/one_context.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'utils/route_aware.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  RuntimeConstants.source = 'hmoe';

  if (!isProd) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
}


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with 
  AfterLayoutMixin, 
  ProviderChangeChecker,
  WidgetsBindingObserver,
  AppInit
{
  Brightness brightness;

  @override
  void initState() { 
    super.initState();
    initSetRootBrightnessMethod(setBrightness);
  }

  // 暂时用不上，保留
  // 这个方法主要是为了能动态修改textField的复制粘贴栏文字颜色，因为目前只能通过设置brightness来修改，而且这个栏在Overlay中渲染，主题只能通过根组件设置
  void setBrightness([Brightness brightness]) {
    Future.microtask(() => setState(() => this.brightness = brightness));
  }

  @override
  Widget build(BuildContext context) {        
    final themeName = context.watch<SettingsProviderModel>().theme;
    final locale = context.watch<SettingsProviderModel>().locale;
    
    return MaterialApp(
      title: RuntimeConstants.source == 'hmoe' ? 'Hmoegirl' : 'Moegirl+',
      theme: themes[themeName],
      onGenerateRoute: router.generator,
      navigatorObservers: [routeObserver, HeroController()],
      builder: OneContext().builder,
      navigatorKey: OneContext().key,

      locale: locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'Hans'),
        Locale('zh', 'Hant')
      ],
    );
  }
}