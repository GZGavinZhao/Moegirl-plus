import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

Future<bool> showAlert({
  String title = '提示',
  String content = '',
  String checkButtonText = '确定',
  String closeButtonText = '取消',
  bool visibleCloseButton = false,
  bool autoClose = true,
  bool barrierDismissible = true,
}) {
  final completer = Completer<bool>();
  final theme = Theme.of(OneContext().context);

  OneContext().showDialog(
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        backgroundColor: theme.colorScheme.surface,
        content: SingleChildScrollView(
          child: ListBody(
            children: [Text(content)],
          ),
        ),
        actions: [
          if (visibleCloseButton) (
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(theme.splashColor),
                foregroundColor: MaterialStateProperty.all(theme.hintColor)
              ),
              onPressed: () {
                if (autoClose) Navigator.of(context).pop();
                completer.complete(false);
              },
              child: Text(closeButtonText),
            )
          ),  
          
          TextButton(
            onPressed: () {
              if (autoClose) Navigator.of(context).pop();
              completer.complete(true);
            },
            child: Text(checkButtonText),
          ),
        ],
      );
    }
  )
    .then((value) {
      if (!completer.isCompleted) completer.complete(false);
    });

  return completer.future;
}