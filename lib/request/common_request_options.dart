import 'package:dio/dio.dart';

var commonRequestOptions = BaseOptions(
  connectTimeout: 3000,
  receiveTimeout: 7000,
  contentType: Headers.formUrlEncodedContentType,
  headers: {
    'Cache-Control': 'no-cache'
  } 
);