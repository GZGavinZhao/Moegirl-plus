import 'dart:convert';

String createMoegirlRendererConfig([
  String pageName = '未命名',
  List<String> categories
]) {
  final categoriesStr = jsonEncode(categories ?? []);
  
  return '''
    moegirl.data.pageName = '$pageName'

    moegirl.config.link.onClick = (data) => _postMessage('link', data)
    moegirl.config.biliPlayer.onClick = (data) => _postMessage('biliPlayer', data)
    moegirl.config.biliPlayer.onLongPress = (data) => _postMessage('biliPlayerLongPress', data)
    moegirl.config.request.onRequested = (data) => _postMessage('request', data)
    moegirl.config.vibrate.onCalled = () => _postMessage('vibrate')
    moegirl.config.addCategories.categories = $categoriesStr

    moegirl.init()
  ''';
}