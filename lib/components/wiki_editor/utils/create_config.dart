import 'package:moegirl_plus/utils/encode_js_eval_codes.dart';

Future<String> createWikiEditorConfig(String initialValue) async {  
  final encodedInitialValue = await encodeJsEvalCodes(initialValue);

  return '''
    window.config = {
      initialValue: '$encodedInitialValue',
      onChanged: (text) => _postMessage('onChanged', text),
      onFocused: _postMessage('onFocused'),
      onBlurred: _postMessage('onBlurred')
    }

    init()
  ''';
}