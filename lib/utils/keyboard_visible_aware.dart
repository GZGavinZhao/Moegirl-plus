// @dart=2.9
import 'package:flutter/material.dart';

mixin KeyboardVisibleAware<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  @mustCallSuper void didShowKeyboard() {}
  @mustCallSuper void didHideKeyboard() {}
  
  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() { 
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  didChangeMetrics() {
    super.didChangeMetrics();
    final isShow = EdgeInsets.fromWindowPadding(WidgetsBinding.instance.window.viewInsets, WidgetsBinding.instance.window.devicePixelRatio).bottom != 0.0;
    isShow ? didShowKeyboard() : didHideKeyboard();
  }
}