import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: color)
  );
}

void setStatusBarVisible(bool visible) {
  SystemChrome.setEnabledSystemUIOverlays([
    if (visible) SystemUiOverlay.top,
    SystemUiOverlay.bottom
  ]);
}