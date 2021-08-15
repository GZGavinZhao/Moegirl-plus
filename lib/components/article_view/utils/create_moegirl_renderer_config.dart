import 'dart:convert';

import 'package:flutter/material.dart';

String createMoegirlRendererConfig({
  @required String pageName,
  @required String language,
  @required String site,
  @required bool enabledCategories,
  @required List<String> categories,
  @required bool enbaledHeightObserver,
  @required bool heimu,
  @required bool nightMode,
  @required bool addCopyright,
}) {
  final categoriesStr = jsonEncode(categories ?? []);
  final heightObserverCodes = '''
    moegirl.config.hostScrollMode.enabled = true
    moegirl.config.hostScrollMode.onResize = height => _postMessage('pageHeightChange', height)
  ''';
  
  return '''
    moegirl.data.pageName = ${jsonEncode(pageName)}
    moegirl.data.language = '$language'
    moegirl.data.site = '$site'
    moegirl.config.heimu.\$enabled = ${heimu.toString()}
    moegirl.config.addCopyright.enabled = ${addCopyright.toString()}
    moegirl.config.nightTheme.\$enabled = ${nightMode.toString()}

    moegirl.config.link.onClick = (data) => _postMessage('link', data)
    moegirl.config.biliPlayer.onClick = (data) => _postMessage('biliPlayer', data)
    moegirl.config.biliPlayer.onLongPress = (data) => _postMessage('biliPlayerLongPress', data)
    moegirl.config.request.onRequested = (data) => _postMessage('request', data)
    moegirl.config.vibrate.onCalled = () => _postMessage('vibrate')
    moegirl.config.addCategories.enabled = ${enabledCategories.toString()}
    moegirl.config.addCategories.categories = $categoriesStr
    moegirl.config.dataCollector.contentsData = data => _postMessage('contentsData', data)
    moegirl.config.poll.onPoll = (data) => _postMessage('poll', data)
    ${enbaledHeightObserver ? heightObserverCodes : ''}
    moegirl.init()
  ''';
}