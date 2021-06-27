import 'dart:convert';

import 'package:flutter/foundation.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJsonTransformer(String text) {
  return compute(_parseAndDecode, text);
}