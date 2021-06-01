import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/article_view/index.dart';
import 'package:moegirl_plus/components/badge.dart';
import 'package:moegirl_plus/components/html_web_view/index.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/components/styled_widgets/refresh_indicator.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/drawer/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool doubleBackToExitAppMark = false;
  Future<bool> willPop() async {    
    if (scaffoldKey.currentState.isDrawerOpen) return true;
    if (!doubleBackToExitAppMark) {
      toast(Lang.doubleBackToExit);
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
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          title: AppBarTitle(Lang.siteName),
          leading: Selector<AccountProviderModel, int>(
            selector: (_, provider) => provider.waitingNotificationTotal,
            builder: (context, waitingNotificationTotal, _) => (
              Stack(
                alignment: Alignment.center,
                children: [
                  AppBarIcon(
                    icon: Icons.menu, 
                    onPressed: Scaffold.of(context).openDrawer
                  ),
                  if (waitingNotificationTotal > 0) (
                    Positioned(
                      top: 13,
                      right: 11,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.primaryColor, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Badge(),
                      )
                    )
                  )
                ],
              )
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