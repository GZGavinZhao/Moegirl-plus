import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/custom_modal_route.dart';
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

  OneContext().push(CustomModalRoute(
    barrierDismissible: barrierDismissible,
    child: Center(
      child: AlertDialog(
        title: Text(title),
        backgroundColor: theme.colorScheme.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
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
                if (autoClose) OneContext().pop();
                completer.complete(false);
              },
              child: Text(closeButtonText),
            )
          ),  
          
          TextButton(
            onPressed: () {
              if (autoClose) OneContext().pop();
              completer.complete(true);
            },
            child: Text(checkButtonText),
          ),
        ],
      ),
    )
  ));

  return completer.future;
}