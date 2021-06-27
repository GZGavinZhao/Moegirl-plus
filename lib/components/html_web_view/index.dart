import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:moegirl_plus/components/html_web_view/utils/create_html_document.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/utils/encode_js_eval_codes.dart';

const _webViewInjectedSendMessageHandlerName = 'default';
const basicInjectedJs = '''
  window._postMessage = (type, data) => {
    window.flutter_inappwebview.callHandler('$_webViewInjectedSendMessageHandlerName', { type, data })
  }
''';

class HtmlWebView extends StatefulWidget {
  final String body;
  final String title;
  final List<String> injectedStyles;
  final List<String> injectedScripts;
  final List<String> injectedFiles;
  final void Function(HtmlWebViewController) onWebViewCreated;
  final Map<String, void Function(dynamic data)> messageHandlers;  
  
  HtmlWebView({
    Key key,
    this.body,
    this.title,
    this.injectedStyles,
    this.injectedScripts,
    this.injectedFiles,
    this.onWebViewCreated,
    this.messageHandlers
  }) : super(key: key);

  @override
  _HtmlWebViewState createState() => _HtmlWebViewState();
}

class _HtmlWebViewState extends State<HtmlWebView> {
  String htmlDocument;
  InAppWebViewController webViewController;

  @override
  void didUpdateWidget(HtmlWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ([
      widget.body != oldWidget.body,
      widget.injectedScripts.toString() != oldWidget.injectedScripts.toString(),
      widget.injectedStyles.toString() != oldWidget.injectedStyles.toString()
    ].contains(true)) {
      reloadWebView();
    }
  }

    // 使用document.write代替reload
  Future<void> reloadWebView() async {
    var htmlDocument = createHtmlDocument(widget.body ?? '',
      title: widget.title,
      injectedFiles: widget.injectedFiles,
      injectedStyles: [
        'body { background-color: ${settingsProvider.theme == 'night' ? '#252526' : 'white'} }',
        ...?widget.injectedStyles,
      ],
      injectedScripts: [
        basicInjectedJs, 
        ...?widget.injectedScripts,
        '_postMessage("loaded")'
      ],
    );

    // 转unicode字符串，防止误解析
    final encodedhtmlDocument = await encodeJsEvalCodes(htmlDocument);
    webViewController.evaluateJavascript(source: '''
      document.open()
      document.write('$encodedhtmlDocument')
      document.close()
    ''');
  }

  void webViewWasLoadStopHandler(InAppWebViewController controller, Uri uri) {
    webViewController = controller;
    webViewController.addJavaScriptHandler(
      handlerName: _webViewInjectedSendMessageHandlerName, 
      callback: (args) {
        final String type = args[0]['type'];
        final dynamic data = args[0]['data'];
        widget.messageHandlers[type](data);    
      }
    );

    reloadWebView();

    if (widget.onWebViewCreated != null) {
      widget.onWebViewCreated(HtmlWebViewController(
        reload: reloadWebView,
        webViewController: controller
      ));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(data: ''),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          transparentBackground: true,
        ),
      ),
      onLoadStop: webViewWasLoadStopHandler,
    );
  }
}

class HtmlWebViewController {
  final void Function() reload; // 自定义一个reload方法
  final InAppWebViewController webViewController;

  HtmlWebViewController({
    this.reload,
    this.webViewController
  });
}