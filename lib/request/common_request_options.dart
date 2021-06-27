import 'package:dio/dio.dart';

var commonRequestOptions = BaseOptions(
  connectTimeout: 7000,
  receiveTimeout: 7000,
  contentType: Headers.formUrlEncodedContentType,
  headers: {
    'Cache-Control': 'no-cache',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.95 Safari/537.36',
    'sec-ch-ua': '" Not A;Brand";v="99", "Chromium";v="90"',
    'sec-ch-ua-mobile': '?0',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'x-requested-with': 'XMLHttpRequest',
    'dnt': '1',
    'pragma': 'no-cache',
    'accept': '*/*',
  } 
);