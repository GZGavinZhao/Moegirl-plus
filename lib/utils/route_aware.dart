// @dart=2.9
import 'package:flutter/material.dart';

final routeObserver = RouteObserver<PageRoute>();

mixin SubscriptionForRouteAware<T extends StatefulWidget> on State<T>, RouteAware {
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }
  
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}