import 'package:dio/dio.dart';

var commonRequestOptions = BaseOptions(
  connectTimeout: 7000,
  receiveTimeout: 9000,
  contentType: Headers.formUrlEncodedContentType,
  headers: {
    'Cache-Control': 'no-cache'
  } 
);