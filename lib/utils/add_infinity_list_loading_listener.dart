import 'package:flutter/cupertino.dart';

void Function() addInfinityListLoadingListener(
  ScrollController scrollController, 
  void Function() loadingFn,
  [double triggerDistance = 100]
) {
  void infinityListLoadingListener() {
    if (scrollController.position.maxScrollExtent - scrollController.position.pixels < triggerDistance) {
      loadingFn();
    }
  }

  scrollController.addListener(infinityListLoadingListener);
  return () => scrollController.removeListener(infinityListLoadingListener);
}