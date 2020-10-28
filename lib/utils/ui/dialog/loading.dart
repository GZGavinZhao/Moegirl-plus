import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/styled_widgets/circular_progress_indicator.dart';
import 'package:one_context/one_context.dart';

Future<void> showLoading({
  String text = '请稍候...',
  bool barrierDismissible = false
}) {
  final completer = Completer();
  final theme = Theme.of(OneContext().context);

  OneContext().showDialog(
    barrierDismissible: barrierDismissible,
    builder: (context) => (
      AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        content: SingleChildScrollView(
          child: Row(
            children: [
              StyledCircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(text),
              )
            ],
          ),
        ),
      )
    )
  );
  
  return completer.future;
}