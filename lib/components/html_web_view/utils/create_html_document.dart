
String createHtmlDocument(String body, {
  String title: 'Document',
  List<String> injectedStyles,
  List<String> injectedScripts
}) {  
  final injectedStyleTagsStr = (injectedStyles ?? []).map((item) => '<style>$item</style>').join('\n');
  final injectedScriptTagsStr = (injectedScripts ?? []).map((item) => '<script>$item</script>').join('\n');
  
  return '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>$title</title>
      $injectedStyleTagsStr
    </head>
      <body>$body</body>
      $injectedScriptTagsStr
    </html>   
  ''';
}