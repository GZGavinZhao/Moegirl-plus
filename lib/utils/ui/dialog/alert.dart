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
  final theme = Theme.of(OneContext().context);

  OneContext().showDialog(
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [Text(content)],
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
          if (visibleCloseButton) (
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(theme.splashColor),
                foregroundColor: MaterialStateProperty.all(theme.hintColor)
              ),
              onPressed: () {
                if (autoClose) Navigator.of(context).pop();
                completer.complete(false);
              },
              child: Text(closeButtonText),
            )
          )  
        ],
      );
    }
  )
    .then((value) {
      if (!completer.isCompleted) completer.complete(false);
    });

  return completer.future;
}