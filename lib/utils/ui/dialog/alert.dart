import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/custom_modal_route.dart';
import 'package:one_context/one_context.dart';

Future<T> showAlert<T>({
  String title = '提示',
  String content = '',
  String checkButtonText = '确定',
  String closeButtonText = '取消',
  bool visibleCloseButton = false,
  bool autoClose = true,
  bool barrierDismissible = true,
  List<Widget> Function(Completer) moreActionsBuilder,
}) {
  final completer = Completer<T>();
  final theme = Theme.of(OneContext().context);

  OneContext().push(CustomModalRoute(
    barrierDismissible: barrierDismissible,
    onWillPop: () async {
      // 很迷，这里如果返回true而不手动pop会导致接下来立刻进行的路由pop操作失效
      // complete放到微任务里也是不行
      // 另外还发现OneContext.pop()有时关不掉pop，总之还是应该换成showDialog的...
      OneContext().pop();
      completer.complete(false as T);
      return false;
    },
    child: Center(
      child: AlertDialog(
        title: Text(title,
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: theme.colorScheme.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
        actions: [          
          ...?moreActionsBuilder(completer),
          
          if (visibleCloseButton) ( 
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(theme.splashColor),
                foregroundColor: MaterialStateProperty.all(theme.hintColor)
              ),
              onPressed: () {
                if (autoClose) OneContext().pop();
                completer.complete(false as T);
              },
              child: Text(closeButtonText),
            )
          ),  
          
          TextButton(
            onPressed: () {
              if (autoClose) OneContext().pop();
              completer.complete(true as T);
            },
            child: Text(checkButtonText),
          ),
        ],
      ),
    )
  ));

  return completer.future;
}