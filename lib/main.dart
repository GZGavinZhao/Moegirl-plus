import 'package:flutter/material.dart';
import 'package:moegirl_viewer/routes/router.dart';
import 'package:moegirl_viewer/utils/can_use_platform_views_for_android_web_view.dart';
import 'package:moegirl_viewer/utils/preferences.dart';
import 'package:moegirl_viewer/utils/ui/set_status_bar.dart';
import 'package:one_context/one_context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prefReady;
  await checkCanUsePlatformViewsForAndroidWebview();
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
        splashFactory: InkRipple.splashFactory
      ),
      onGenerateRoute: router.generator,
      
      builder: OneContext().builder,
      navigatorKey: OneContext().key
    );
  }
}
