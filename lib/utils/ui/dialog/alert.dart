part of './index.dart';

Future<bool> _alert({
  String title = '提示',
  String content = '',
  String checkButtonText = '确定',
  String closeButtonText = '取消',
  bool visibleCloseButton = false,
  bool autoClose = true,
  bool barrierDismissible = true,
}) {
  final completer = Completer<bool>();

  OneContext().showDialog(
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [Text(title)],
          ),
        ),
        actions: [
          TextButton(
            child: Text(checkButtonText),
            onPressed: () {
              if (autoClose) Navigator.of(context).pop();
              completer.complete(true);
            },
          ),
          visibleCloseButton ? 
            TextButton(
              child: Text(closeButtonText),
              onPressed: () {
                if (autoClose) Navigator.of(context).pop();
                completer.complete(false);
              },
            )
          : null,
        ],
      );
    }
  )
    .then((value) => completer.complete(false));

  return completer.future;
}