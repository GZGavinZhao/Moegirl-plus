import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/app_bar_icon.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:moegirl_viewer/components/html_web_view/index.dart';
import 'package:moegirl_viewer/utils/ui/dialog/index.dart';
import 'package:moegirl_viewer/views/drawer/index.dart';
import 'package:one_context/one_context.dart';

class IndexPageRouteArgs {
  

  IndexPageRouteArgs();
}

class IndexPage extends StatefulWidget {
  final IndexPageRouteArgs routeArgs;
  
  IndexPage(this.routeArgs, {Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  HtmlWebViewController htmlWebViewController;
  String webViewBody;
  List<String> injectedStyles;
  List<String> injectedScripts;

  @override
  void initState() {    
    // TODO: implement initState
    super.initState();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    CommonDialog.alert(content: 'aaaa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('萌娘百科'),
        leading: Builder(
          builder: (context) => appBarIcon(Icons.menu, Scaffold.of(context).openDrawer)
        ),
        actions: [
          appBarIcon(Icons.search, () => OneContext().pushNamed('search'))
        ],
      ),
      drawer: globalDrawer(),
      body: Container(
        child: ArticleView(
          pageName: 'Mainpage',
        ),
      ),
    );
  }
}