// @dart=2.9
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

String computeMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}