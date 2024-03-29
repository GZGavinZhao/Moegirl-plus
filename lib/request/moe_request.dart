// @dart=2.9
import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/request/common_request_options.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/views/captcha/index.dart';
import 'package:one_context/one_context.dart';
import 'package:path_provider/path_provider.dart';

String _appDocPath;
// cookieJar传入cookie的存储路径，需要runApp等待异步操作
final Future<void> moeRequestReady = getApplicationDocumentsDirectory().then((value) => _appDocPath = value.path);
final language = settingsProvider.lang.toLowerCase();

final moeRequest = (() {
  final moeRequestDio = Dio(commonRequestOptions);
  moeRequestDio.options.baseUrl = RuntimeConstants.source == 'moegirl' ? apiUrl : apiUrlHmoe;
  moeRequestDio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options, intercepter) {
      options.queryParameters['format'] = 'json';
      options.queryParameters['variant'] = language;
      options.headers['referer'] = RuntimeConstants.source == 'moegirl' 
        ? 'https://zh.moegirl.org.cn'
        : 'https://www.hmoegirl.com'
      ;
      return options;
    }
  ));

  final cookieJar = PersistCookieJar(storage: FileStorage(_appDocPath + '/.cookies/'));
  moeRequestDio.interceptors.add(CookieManager(cookieJar));

  Future<Map> moeRequest({ 
    String method = 'get',
    Map<String, dynamic> params,
    String baseUrl,
    Map<String, dynamic> headers,
  }) {
    return moeRequestDio.request(baseUrl,
      queryParameters: method == 'get' ? params : null,
      data: method == 'post' ? params : null,
      options: Options(
        method: method,
        // baseUrl: baseUrl,
        headers: headers
      )
    )
      .then((res) async {
        final dynamic data = res.data;
        final resultCompleter = Completer();
        
        // 投票返回的内容是html字符串，因为已经指定了请求函数的返回类型为map，
        // 再改成dynamic的话其他api函数都要改，只好这里妥协包个map
        if (res.requestOptions.queryParameters['rs'] == 'AJAXPoll::submitVote') {
          return { 'content': res.data };
        }

        if (data is String) {
          OneContext().pushNamed('/captcha', arguments: CaptchaPageRouteArgs(
            html: data,
            resultCompleter: resultCompleter 
          ));

          final validatedResult = await resultCompleter.future;
          if (validatedResult) {
            return moeRequest(
              params: res.requestOptions.queryParameters,
              method: res.requestOptions.method.toLowerCase(),
              baseUrl: res.requestOptions.baseUrl,
              headers: res.requestOptions.headers
            );
          } else {
            return Future(() {
              throw MoeRequestError({
                'code': '-1',
                'info': 'captcha验证失败' 
              });
            });
          }
        } else {
          if (data.containsKey('error')) throw MoeRequestError(data['error']);
          return data;
        }
      });
  }

  return moeRequest;
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