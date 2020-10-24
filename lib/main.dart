import 'package:flutter/material.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/comment.dart';
import 'package:moegirl_viewer/providers/settings.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/routes/router.dart';
import 'package:moegirl_viewer/themes.dart';
import 'package:moegirl_viewer/utils/can_use_platform_views_for_android_web_view.dart';
import 'package:moegirl_viewer/utils/ui/set_status_bar.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import 'utils/route_aware.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 等待必要数据加载完毕
  await Future.wait([
    prefReady,
    checkCanUsePlatformViewsForAndroidWebview(),
    moeRequestReady
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

class MyApp extends StatelessWidget {  
  
  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProviderModel, String>(
      selector: (_, model) => model.theme,
      builder: (_, theme, __) => (
        MaterialApp(
          title: 'Moegirl Viewer',
          theme: themes[theme],
          onGenerateRoute: router.generator,
          navigatorObservers: [routeObserver],
          builder: OneContext().builder,
          navigatorKey: OneContext().key
        )
      )
    );
  }
}


