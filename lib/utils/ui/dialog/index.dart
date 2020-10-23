import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/styled/circular_progress_indicator.dart';
import 'package:one_context/one_context.dart';

part './alert.dart';
part './loading.dart';

class CommonDialog {
  static final alert = _alert;
  static final loading = _loading;
  static popDialog() => OneContext().popDialog();
}