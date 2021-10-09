// @dart=2.9
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/article/index.dart';

import 'index.dart';

class Route {
  final Widget Function(dynamic routeArgs) pageBuilder;
  final TransitionType transitionType;
  Route(this.pageBuilder, [this.transitionType = TransitionType.cupertino]);
}

final router = (() {
  final router = FluroRouter();

  routes.forEach((path, route) {
    router.define(path, 
      handler: Handler(
        handlerFunc: (context, parameters) => 
          WillPopScope(
            onWillPop: () async => !Navigator.of(context).userGestureInProgress,
            child: route.pageBuilder(ModalRoute.of(context).settings.arguments),
          )
        ,
      ),
      transitionType: route.transitionType
    );
  });

  router.define('/:pageName', handler: Handler(
      handlerFunc: (context, parameters) {
        final pageName = ModalRoute.of(context).settings.name.replaceFirst('/', '');
        if (pageName.contains(RegExp(r'^index\.php'))) {
          toast('暂不支持该链接格式');
          return null;
        } else {
          return WillPopScope(
            onWillPop: () async => !Navigator.of(context).userGestureInProgress,
            child: ArticlePage(ArticlePageRouteArgs(pageName: pageName)),
          );
        }
      },
    ),
    transitionType: TransitionType.cupertino
  );

  return router;
})();