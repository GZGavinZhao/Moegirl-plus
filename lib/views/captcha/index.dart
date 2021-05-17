import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as HtmlDom;
import 'package:html/parser.dart';
import 'package:moegirl_plus/request/plain_request.dart';
import 'package:moegirl_plus/utils/encode_js_eval_codes.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:one_context/one_context.dart';

class WebViewPageRouteArgs {
  final String html;
  
  WebViewPageRouteArgs({
    @required this.html
  });
}

class WebViewPage extends StatefulWidget {
  final WebViewPageRouteArgs routeArgs;
  
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

        if(res.ret === 0){
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

    controller.addJavaScriptHandler(
      handlerName: 'validated', 
      callback: (content) {
        plainRequest.post('https://zh.moegirl.org.cn/WafCaptcha', 
          data: content,
          options: Options(
            headers: {
              'origin': 'https://zh.moegirl.org.cn',
              'referer': 'https://zh.moegirl.org.cn/Mainpage',
              'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.95 Safari/537.36'
            },
          )
        )
          .then((value) {
            OneContext().pop();
          })
          .catchError((e) async {
            print('captcha验证失败');
            print(e);
            OneContext().pop();
        });
      }
    );
    
    controller.evaluateJavascript(source: '''
      document.open('text/html', 'replace')
      document.write('$encodedhtmlDocument')
      document.close()
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InAppWebView(
        initialData: InAppWebViewInitialData(data: ''),
        onLoadStop: initWebViewContent,
      ),
    );
  }
}

class CaptchaErr implements Exception {
  @override
  String toString() => '[CaptchaErr]';
}