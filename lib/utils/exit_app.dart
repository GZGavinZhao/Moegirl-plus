// @dart=2.9
import 'package:flutter/services.dart';

void exitApp() => SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');