part of './index.dart';

Future<void> _loading({
  String text = '请稍候...',
  bool barrierDismissible = false
}) {
  final completer = Completer();

  OneContext().showDialog(
    barrierDismissible: barrierDismissible,
    builder: (context) => (
      AlertDialog(
        content: SingleChildScrollView(
          child: Row(
            children: [
              CircularProgressIndicator(),
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