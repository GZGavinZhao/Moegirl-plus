import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:one_context/one_context.dart';

void showNoteDialog(String content) {
  final theme = Theme.of(OneContext().context);
  
  OneContext().showDialog(
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text('注释'),
        backgroundColor: theme.colorScheme.surface,
        content: SizedBox(
          height: MediaQuery.of(OneContext().context).size.height * 0.2,
          child: ArticleView(
            inDialogMode: true,
            html: content,
          ),
        ),
        actions: [
          TextButton(
            child: Text('关闭'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}