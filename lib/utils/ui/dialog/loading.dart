part of './index.dart';

Future<void> _loading({
  String text = '请稍候...',
  bool barrierDismissible = false
}) {
  final completer = Completer();
  final theme = Theme.of(OneContext().context);

  OneContext().showDialog(
    barrierDismissible: barrierDismissible,
    builder: (context) => (
      AlertDialog(
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
  );
  
  return completer.future;
}