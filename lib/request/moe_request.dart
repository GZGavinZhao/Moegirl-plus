import 'package:dio/dio.dart';
import 'package:moegirl_viewer/request/common_request_options.dart';

const _apiUrl = 'https://zh.moegirl.org.cn/api.php';

final moeRequest = (() {
  final moeRequestDio = Dio(commonRequestOptions);
  moeRequestDio.options.baseUrl = _apiUrl;
  moeRequestDio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      options.queryParameters['format'] = 'json';
      return options;
    }
  ));

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
  String toString() => 'MoeRequestError $code: $info';
}