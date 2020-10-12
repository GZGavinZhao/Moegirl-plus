import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

import 'components/animation.dart';

enum ToastPosition {
  top, center, bottom
}

class Toast extends StatefulWidget {
  final String text;
  final ToastPosition position;
  final Function(ToastAnimationController) onControllerCreated;

  const Toast({
    Key key,
    this.text,
    this.position,
    this.onControllerCreated
  }) : super(key: key);

  @override
  _ToastState createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  @override
  void initState() { 
    super.initState();
  }

  get toastPositionContainer => {
    ToastPosition.top: (Widget child) => Positioned(top: 70, left: 0, right: 0, child: child),
    ToastPosition.center: (Widget child) => Positioned(top: 0, bottom: 0, left: 0, right: 0, child: child),
    ToastPosition.bottom: (Widget child) => Positioned(bottom: 70, left: 0, right: 0, child: child)
  }[widget.position];

  @override
  Widget build(BuildContext context) {
    final toastBody = Container(
      child: Text(widget.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
      ),
      padding: const EdgeInsets.only(
        top: 10, bottom: 10,
        left: 20, right: 20
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.7),
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
    );
    
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          toastPositionContainer(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToastAnimationWrapper(
                  toast: toastBody,
                  onControllerCreated: widget.onControllerCreated,
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

toast (String text, {
  ToastPosition position = ToastPosition.bottom,
  int duration = 3000
}) async {
  var controllerCompleter = Completer<ToastAnimationController>();
  
  final overlayEntry = OverlayEntry(
    builder: (context) => Toast(
      text: text, 
      position: position,
      onControllerCreated: controllerCompleter.complete,
    )
  );

  Overlay.of(OneContext().context).insert(overlayEntry);
  final controller = await controllerCompleter.future;
  controller.show();
  await Future.delayed(Duration(milliseconds: duration));
  await controller.hide();
  overlayEntry.remove();
}