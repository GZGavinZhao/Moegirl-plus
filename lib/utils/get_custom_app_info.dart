

import 'dart:convert';

import 'package:flutter/services.dart';

final customAppInfoFuture = rootBundle.loadString('assets/app.json');

Future<CustomAppInfo> getCustomAppInfo() async {
  final rawData = jsonDecode(await customAppInfoFuture);
  return CustomAppInfo.fromMap(rawData);
}

class CustomAppInfo {
  final String date;

  CustomAppInfo({
    this.date
  });

  CustomAppInfo.fromMap(Map map) : 
    this.date = map['date']
  ;
}