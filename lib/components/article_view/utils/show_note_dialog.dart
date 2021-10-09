// @dart=2.9

import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/article_view/index.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/color2rgb_css.dart';
import 'package:one_context/one_context.dart';

void showNoteDialog(BuildContext context, String content) {
  showDialog(
    context: context,
    barrierDismissible: true,
    useRootNavigator: false,
    builder: (context) {
      final theme = Theme.of(context);
      
      return AlertDialog(
        title: Text(Lang.note,
          style: TextStyle(fontSize: 18)
        ),
        backgroundColor: theme.colorScheme.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
        content: SizedBox(
          height: MediaQuery.of(OneContext().context).size.height * 0.2,
          child: ArticleView(
            inDialogMode: true,
            html: content,
            injectedStyles: ['body { background-color: ${color2rgbCss(theme.colorScheme.surface)} !important }'],
          ),
        ),
        actions: [
          TextButton(
            child: Text(Lang.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}