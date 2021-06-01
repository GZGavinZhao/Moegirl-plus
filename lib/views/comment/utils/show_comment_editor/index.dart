import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/custom_modal_route.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:one_context/one_context.dart';

class CommentEditor extends StatefulWidget {
  final String title;
  final String placeholder;
  final String initialValue;
  final void Function(CommentEditorController) emitController;
  final void Function(String) onChanged;
  final void Function() onSubmit;

  CommentEditor({
    @required this.title,
    @required this.placeholder,
    this.initialValue,
    this.emitController,
    this.onChanged,
    this.onSubmit,
    Key key
  }) : super(key: key);

  @override
  _CommentEditorState createState() => _CommentEditorState();
}

class _CommentEditorState extends State<CommentEditor> {
  final animationDuration = Duration(milliseconds: 300);
  double backgroundOpacity = 0;
  double bodyPositionBottom = -150;
  bool enabledSubmitButton = false;

  final focusNode = FocusNode();
  final contoller = TextEditingController();
  
  @override
  void initState() { 
    super.initState();
    widget.emitController(CommentEditorController(show, hide));
    
    contoller.text = widget.initialValue;
    enabledSubmitButton = widget.initialValue != null ? widget.initialValue.trim() != '' : false;
  }

  @override
  void dispose() { 
    focusNode.dispose();
    super.dispose();
  }

  Future<void> show() {
    setState(() {
      backgroundOpacity = 0.5;
      bodyPositionBottom = 0;
    });

    return Future.delayed(animationDuration);
  }

  Future<void> hide() {
    setState(() {
      backgroundOpacity = 0;
      bodyPositionBottom = -150;
    });

    return Future.delayed(animationDuration);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: animationDuration,
            curve: Curves.ease,
            left: 0,
            bottom: bodyPositionBottom,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.textTheme.bodyText1.color
                          ),
                        ),
                        TouchableOpacity(
                          onPressed: enabledSubmitButton ? widget.onSubmit : null,
                          child: Text(Lang.publish,
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.accentColor
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: contoller,
                      autofocus: true,
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      cursorHeight: 20,
                      
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: widget.placeholder,
                        hintStyle: TextStyle(
                          color: theme.disabledColor
                        )
                      ),
                      onChanged: (text) {
                        setState(() => enabledSubmitButton = text.trim() != '');
                        widget.onChanged(text);
                      },
                    )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<String> showCommentEditor({
  @required String targetName,
  String initialValue,
  bool isReply = false,
}) async {
  String inputValue = initialValue ?? '';
  final resultCompleter = Completer<String>();
  final controllerCompleter = Completer<CommentEditorController>();

  void show() async {
    final controller = await controllerCompleter.future;
    controller.show();
  }

  Future<bool> willPopHandler() async {
    if (resultCompleter.isCompleted) return true;
    
    final _inputValue = inputValue.trim();
    if (_inputValue != '') {
      final result = await showAlert(
        content: Lang.commentLeaveHint,
        visibleCloseButton: true
      );

      if (!result) return false;
    }
    
    final controller = await controllerCompleter.future;
    await controller.hide();  // 等待动画结束再退，这样会好看一点

    // 这里要确保先退出当前路由后，再返回给结果回调，防止连续showCommentEditor时在上个modal还未退出时就push了新modal
    Future.microtask(resultCompleter.complete); 
    return true;
  }

  final actionName = isReply ? Lang.reply : Lang.talk;
  OneContext().push(CustomModalRoute(
    transitionDuration: Duration(milliseconds: 300),
    onWillPop: willPopHandler,
    child: CommentEditor(
      title: actionName,
      placeholder: '$actionName：$targetName',
      initialValue: initialValue,
      emitController: controllerCompleter.complete,
      onChanged: (text) => inputValue = text,
      onSubmit: () {
        resultCompleter.complete(inputValue);
        controllerCompleter.future.then((controller) => controller.hide());
        OneContext().pop();
      },
    )
  ));

  show();
  
  return resultCompleter.future;
}

class CommentEditorController {
  final Future<void> Function() show;
  final Future<void> Function() hide;

  CommentEditorController(this.show, this.hide);
}