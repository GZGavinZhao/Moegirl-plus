package com.moegirlviewer

import android.view.Window
import android.os.Bundle
import android.graphics.Color
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState);
    val window: Window = getWindow();
    window.setStatusBarColor(Color.TRANSPARENT);
  }
}
