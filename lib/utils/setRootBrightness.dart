// @dart=2.9
// 暂时用不上了
import 'package:flutter/material.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/utils/route_aware.dart';

void Function([Brightness brightness]) setRootBrightness = ([Brightness brightness]) {};

void initSetRootBrightnessMethod(Function method) {
  setRootBrightness = method;
}

// 解决TextField组件复制粘贴栏文字颜色因根组件主题Brightness.dark导致的文字颜色与背景色同色的问题
mixin LightRootBrightness<T extends StatefulWidget> on 
  State<T>, RouteAware, SubscriptionForRouteAware<T> 
{
  Brightness get _lightBrightness => settingsProvider.theme == 'night' ? null : Brightness.light; 

  @override
  void didPush() { 
    super.didPush();
    setRootBrightness(_lightBrightness);
  }

  @override
  void didPushNext() {
    super.didPushNext();
    setRootBrightness(null);
  }

  @override
  void didPop() {
    super.didPop();
    setRootBrightness(null);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    setRootBrightness(_lightBrightness);
  }
}