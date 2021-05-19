import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as HtmlDom;
import 'package:html/parser.dart';
import 'package:moegirl_plus/request/plain_request.dart';
import 'package:moegirl_plus/utils/encode_js_eval_codes.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:one_context/one_context.dart';

class CaptchaPageRouteArgs {
  final String html;
  final Completer resultCompleter;
  
  CaptchaPageRouteArgs({
    @required this.html,
    @required this.resultCompleter,
  });
}

class WebViewPage extends StatefulWidget {
  final CaptchaPageRouteArgs routeArgs;
  
  WebViewPage(this.routeArgs, {
    Key key
  }) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  initWebViewContent(InAppWebViewController controller, Uri url) async {
    final htmlDoc = parse(widget.routeArgs.html);
    // 移除最后一个执行脚本，使用自定义的逻辑
    htmlDoc.head.querySelectorAll('script').last.remove();
    
    // 添加viewprot
    final viewProtMetaTag = HtmlDom.Element.tag('meta');
    viewProtMetaTag.attributes['name'] = 'viewport';
    viewProtMetaTag.attributes['content'] = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
    htmlDoc.head.append(viewProtMetaTag);
    
    // 添加验证逻辑，显示验证码
    final scriptTag = HtmlDom.Element.tag('script');
    scriptTag.innerHtml = '''
      const captcha = new TencentCaptcha('2000490482', function(res) {
        const captchaResult = []
        captchaResult.push(res.ret)

        if (res.ret === 2) {
          window.flutter_inappwebview.callHandler('closed')
          return 
        }

        if (res.ret === 0) {
          captchaResult.push(res.ticket)
          captchaResult.push(res.randstr)
          captchaResult.push(seqid)
        }

        const content = captchaResult.join('\\n')
        window.flutter_inappwebview.callHandler('validated', content)
      })

      captcha.show()
    ''';
    htmlDoc.head.append(scriptTag);
    
    final encodedhtmlDocument = await encodeJsEvalCodes(htmlDoc.outerHtml);
    void execInject() {
      controller.evaluateJavascript(source: '''
        document.open('text/html', 'replace')
        document.write('$encodedhtmlDocument')
        document.close()
      ''');
    }

    controller.addJavaScriptHandler(
      handlerName: 'closed',
      callback: (_) async {
        final result = await showAlert(
          content: '关闭验证数据将无法正常获取，是否返回返回重新验证？',
          visibleCloseButton: true,
          checkButtonText: '好的',
          closeButtonText: '不了'
        );

        if (result) {
          controller.evaluateJavascript(source: 'captcha.show()');
        } else {
           widget.routeArgs.resultCompleter.complete(false);
          OneContext().pop();
        }
      }
    );

    controller.addJavaScriptHandler(
      handlerName: 'validated', 
      callback: (args) {
        final String content = args[0];
        
        plainRequest.post('https://zh.moegirl.org.cn/WafCaptcha', 
          data: content,
          options: Options(
            headers: {
              'origin': 'https://zh.moegirl.org.cn',
              'referer': 'https://zh.moegirl.org.cn/Mainpage',
              'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.95 Safari/537.36',
              'sec-ch-ua': '" Not A;Brand";v="99", "Chromium";v="90"',
              'sec-ch-ua-mobile': '?0',
              'sec-fetch-dest': 'empty',
              'sec-fetch-mode': 'cors',
              'sec-fetch-site': 'same-origin'
            },
          )
        )
          .whenComplete(OneContext().pop)
          .then((value) {
            print('captcha验证成功');
            widget.routeArgs.resultCompleter.complete(true);
          })
          .catchError((e) async {
            print('captcha验证失败');
            print(e);
            widget.routeArgs.resultCompleter.complete(false);
        });
      }
    );

    execInject();
  }

  Future<bool> popIntercept() async {
    final result = await showAlert(
      content: '关闭验证数据将无法正常获取，是否返回返回重新验证？',
      visibleCloseButton: true,
      checkButtonText: '好的',
      closeButtonText: '不了'
    );

    if (result) return false;
    widget.routeArgs.resultCompleter.complete(false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: popIntercept,
      child: Container(
        alignment: Alignment.center,
        child: InAppWebView(
          initialData: InAppWebViewInitialData(data: '', baseUrl: Uri.parse('https://zh.moegirl.org.cn/Mainpage')),
          onLoadStop: initWebViewContent,
          onCreateWindow: (_, __) async => false,
          shouldOverrideUrlLoading: (_, __) async => NavigationActionPolicy.CANCEL,
        ),
      ),
    );
  }
}