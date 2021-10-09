// @dart=2.9

String createHtmlDocument(String body, {
  String title: 'Document',
  List<String> injectedStyles,
  List<String> injectedScripts = const [],
  List<String> injectedFiles = const [],
  List<String> injectedScriptsFirst = const []
}) {  
  final injectedStyleTagsStr = (injectedStyles ?? []).map((item) => '<style>$item</style>').join('\n');
  final injectedScriptTagsStr = (injectedScripts ?? []).map((item) => '<script>$item</script>').join('\n');
  final injectedScriptsFirstTagsStr = (injectedScriptsFirst ?? []).map((item) => '<script>$item</script>').join('\n');

  final injectedCssFileTagsStr = injectedFiles
    .where((item) => item.contains(RegExp(r'\.css$')))
    .map((item) => '<link rel="stylesheet" type="text/css" href="file:///android_asset/flutter_assets/assets/$item">')
    .join('\n');

  final injectedJsFileTagsStr = injectedFiles
    .where((item) => item.contains(RegExp(r'\.js$')))
    .map((item) => '<script src="file:///android_asset/flutter_assets/assets/$item"></script>')
    .join('\n');
  
  return '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>$title</title>
      $injectedScriptsFirstTagsStr
      $injectedCssFileTagsStr
      $injectedStyleTagsStr
    </head>
      <body>$body</body>
      $injectedJsFileTagsStr
      $injectedScriptTagsStr
    </html>   
  ''';
}