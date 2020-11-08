import 'package:flutter/foundation.dart';

Future<String> _func(String codes) async {
  return codes.codeUnits
    .map((item) => '\\u' + (item.toRadixString(16).padLeft(4, '0')))
    .join();
}

Future<String> encodeJsEvalCodes(String codes) {
  return compute(_func, codes);
}