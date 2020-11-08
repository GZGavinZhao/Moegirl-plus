import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:moegirl_viewer/components/html_web_view/index.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_viewer/components/styled_widgets/refresh_indicator.dart';
import 'package:moegirl_viewer/utils/ui/toast/index.dart';
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
  ArticleViewController articleViewController;

  @override
  void initState() { 
    super.initState();
  }

  bool doubleBackToExitAppMark = false;
  Future<bool> willPop() async {
    if (!doubleBackToExitAppMark) {
      toast('再次按下退出程序');
      doubleBackToExitAppMark = true;
      Future.delayed(Duration(seconds: 3))
        .then((_) => doubleBackToExitAppMark = false);
      return false;
    }

    doubleBackToExitAppMark = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: AppBarTitle('萌娘百科'),
          leading: Builder(
            builder: (context) => AppBarIcon(
              icon: Icons.menu, 
              onPressed: Scaffold.of(context).openDrawer
            )
          ),
          actions: [
            AppBarIcon(
              icon: Icons.search, 
              onPressed: () => OneContext().pushNamed('/search')
            )
          ],
        ),
        drawer: GlobalDrawer(),
        body: Container(
          alignment: Alignment.center,
          child: StyledRefreshIndicator(
            onRefresh: () => Future(() {
              articleViewController.reload(true);
              // 这里立刻完成，也就是loading时不显示RefreshIndicator，只在下拉时显示
            }),
            child: ArticleView(
              pageName: 'Mainpage',
              emitArticleController: (controller) => articleViewController = controller,
            ),
          ),
        ),
      ),
    );
  }
}