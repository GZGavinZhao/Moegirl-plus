import 'dart:io';

import 'package:device_info/device_info.dart';

bool canUsePlatformViewsForAndroidWebview;

Future<void> checkCanUsePlatformViewsForAndroidWebview() async {
  if (Platform.isAndroid == false) return;
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  canUsePlatformViewsForAndroidWebview = androidInfo.version.sdkInt >= 29;
}