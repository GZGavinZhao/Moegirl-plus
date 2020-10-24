import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router;

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

  return router;
})();