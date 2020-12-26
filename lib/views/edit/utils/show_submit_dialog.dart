import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/custom_modal_route.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:one_context/one_context.dart';

const quickSummaryList = ['修饰语句', '修正笔误', '内容扩充', '排版'];

Future<EditPageSummaryDialogInputResult> showEditPageSubmitDialog([String initialValue = '']) {
  final completer = Completer<EditPageSummaryDialogInputResult>();
  final theme = Theme.of(OneContext().context);

  final textEditingController = TextEditingController(text: initialValue);

  void insertQuickSummary(String text) {
    textEditingController.text += text;
    textEditingController.selection = TextSelection(
      baseOffset: textEditingController.text.length,
      extentOffset: textEditingController.text.length
    );
  }

  OneContext().push(CustomModalRoute(
    barrierDismissible: false,
    child: Center(
      child: AlertDialog(
        title: Text('提交编辑'),
        backgroundColor: theme.colorScheme.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(OneContext().context).size.width,
            child: ListBody(
              children: [
                TextField(
                  controller: textEditingController,
                  cursorHeight: 22,
                  maxLength: 200,
                  maxLengthEnforced: true,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '请输入摘要',
                  ),
                ),

                Text('快速摘要',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),

                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                    return true;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: quickSummaryList.map((summary) =>
                        _quickSummaryButton(
                          text: summary, 
                          onPressed: () => insertQuickSummary(summary)
                        )
                      ).toList()
                    )
                  ),
                )
              ],
            )
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(theme.splashColor),
              foregroundColor: MaterialStateProperty.all(theme.hintColor)
            ),
            onPressed: () {
              OneContext().pop();
              completer.complete(EditPageSummaryDialogInputResult(false, textEditingController.text));
            },
            child: Text('取消'),
          ),
          
          TextButton(
            onPressed: () {
              OneContext().pop();
              completer.complete(EditPageSummaryDialogInputResult(true, textEditingController.text));
            },
            child: Text('提交'),
          ),
        ],
      ),
    )
  ));

  return completer.future;
}

Widget _quickSummaryButton({
  @required String text,
  @required onPressed,
}) {
  final theme = Theme.of(OneContext().context);
  
  return TouchableOpacity(
    onPressed: onPressed,
    child: Container(
      margin: EdgeInsets.only(top: 10, right: 5),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: theme.dividerColor
      ),
      child: Text(text,
        style: TextStyle(
          fontSize: 14,
          color: theme.textTheme.bodyText1.color,
        ),
      ),
    ),
  );
}

class EditPageSummaryDialogInputResult {
  final bool submit;
  final String summary;

  EditPageSummaryDialogInputResult(this.submit, this.summary);
}