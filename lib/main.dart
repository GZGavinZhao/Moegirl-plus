import 'package:flutter/material.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/routes/router.dart';
import 'package:moegirl_viewer/utils/can_use_platform_views_for_android_web_view.dart';
import 'package:moegirl_viewer/utils/ui/set_status_bar.dart';
import 'package:one_context/one_context.dart';

import 'mobx/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 等待必要数据加载完毕
  await Future.wait([
    prefReady,
    mobxReady,
    checkCanUsePlatformViewsForAndroidWebview(),
    moeRequestReady
  ]);

  runApp(MyApp());
  setStatusBarColor(Colors.transparent);
}

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: InkRipple.splashFactory,
      ),
      onGenerateRoute: router.generator,
      builder: OneContext().builder,
      navigatorKey: OneContext().key
    );
  }
}
