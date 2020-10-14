import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

part './alert.dart';
part './loading.dart';

class CommonDialog {
  static final alert = _alert;
  static final loading = _loading;
  static popDialog() => OneContext().popDialog();
}