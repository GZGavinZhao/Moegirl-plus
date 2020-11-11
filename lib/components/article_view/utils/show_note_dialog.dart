
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:one_context/one_context.dart';

void showNoteDialog(BuildContext context, String content) {
  final theme = Theme.of(OneContext().context);
  
  showDialog(
    context: context,
    barrierDismissible: true,
    useRootNavigator: false,
    builder: (context) {
      return AlertDialog(
        title: Text('注释'),
        backgroundColor: theme.colorScheme.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
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