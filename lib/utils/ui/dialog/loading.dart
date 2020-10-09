part of './index.dart';

Future<void> _loading({
  String title = '请稍候...',
  bool barrierDismissible = false
}) {
  final completer = Completer();

  OneContext().showDialog(
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              CircularProgressIndicator(),
              Text(title),
            ],
          ),
        ),
      );
    }
  );
  
  return completer.future;
}