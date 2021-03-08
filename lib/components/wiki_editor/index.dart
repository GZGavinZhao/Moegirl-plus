// 这个暂时没法使用，不开webView platformViews会导致无法复制，动态设置platformViews会出问题

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/components/html_web_view/index.dart';
import 'package:moegirl_plus/components/wiki_editor/utils/create_config.dart';
import 'package:moegirl_plus/utils/color2rgb_css.dart';

final editorJsFuture = rootBundle.loadString('assets/editor.js');

class WikiEditor extends StatefulWidget {
  final String initialValue;
  final void Function(String) onChanged;
  
  WikiEditor({
    this.initialValue = '',
    this.onChanged,
    Key key
  }) : super(key: key);

  @override
  _WikiEditorState createState() => _WikiEditorState();
}

class _WikiEditorState extends State<WikiEditor> {
  List<String> injectedScripts;
  HtmlWebViewController htmlWebViewController;

  @override
  void initState() { 
    super.initState();
    loadJs();
  }

  void loadJs() async {
    final jsCodes = await editorJsFuture;
    final config = await createWikiEditorConfig(widget.initialValue);
    setState(() => injectedScripts = [jsCodes, config]);
  }

  Map<String, void Function(dynamic data)> get messageHandlers {
    return {
      'onChanged': (text) {
        print('aaa');
      }
    };
  }
   
  get injectedCss {
    final theme = Theme.of(context);
    return '''
      :root {
        --bgColor: ${color2rgbCss(theme.backgroundColor)};
        --textColor: ${color2rgbCss(theme.textTheme.bodyText1.color)};
        --caretColor: ${color2rgbCss(theme.accentColor)};
        }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    
    return HtmlWebView(
      title: 'editor',
      injectedStyles: [injectedCss],
      injectedScripts: injectedScripts,
      messageHandlers: messageHandlers,
      onWebViewCreated: (controller) => htmlWebViewController = controller,
    );
  }
}