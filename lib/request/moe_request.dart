import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/request/common_request_options.dart';
import 'package:path_provider/path_provider.dart';

String _appDocPath;
// cookieJar传入cookie的存储路径，需要runApp等待异步操作
final Future<void> moeRequestReady = getApplicationDocumentsDirectory().then((value) => _appDocPath = value.path);

final moeRequest = (() {
  final moeRequestDio = Dio(commonRequestOptions);
  moeRequestDio.options.baseUrl = apiUrl;
  moeRequestDio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      options.queryParameters['format'] = 'json';
      return options;
    }
  ));

  final cookieJar = PersistCookieJar(dir: _appDocPath + '/.cookies/');
  moeRequestDio.interceptors.add(CookieManager(cookieJar));

  return ({ 
    String method = 'get',
    Map<String, dynamic> params,
    String baseUrl,
    Map<String, dynamic> headers,
  }) {
    return moeRequestDio.request('',
      queryParameters: method == 'get' ? params : null,
      data: method == 'post' ? params : null,
      options: RequestOptions(
        method: method,
        baseUrl: baseUrl,
        headers: headers
      )
    )
      .then((res) {
        final Map data = res.data;
        if (data.containsKey('error')) throw MoeRequestError(data['error']);
        return data;
      });
  };
})();

class MoeRequestError implements Exception {
  String code;
  String info;

  MoeRequestError(dynamic errInfo) {
    code = errInfo['code'];
    info = errInfo['info'];
  }

  @override
  String toString() => '[MoeRequestError] $code: $info';
}