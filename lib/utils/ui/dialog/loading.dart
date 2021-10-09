// @dart=2.9

import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/custom_modal_route.dart';
import 'package:moegirl_plus/components/styled_widgets/circular_progress_indicator.dart';
import 'package:one_context/one_context.dart';

void showLoading({
  String text = '请稍候...',
  bool barrierDismissible = false,
}) {
  final theme = Theme.of(OneContext().context);

  OneContext().push(CustomModalRoute(
    onWillPop: () async => barrierDismissible,
    barrierDismissible: barrierDismissible,
    child: Center(
      child: AlertDialog(
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
  ));
}