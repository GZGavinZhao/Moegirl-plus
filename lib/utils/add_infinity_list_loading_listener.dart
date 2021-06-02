import 'package:flutter/cupertino.dart';

void Function() addInfinityListLoadingListener(
  ScrollController scrollController, 
  void Function() loadingFn,
  [double triggerDistance = 100]
) {
  void checkDistance() {
    if (scrollController.position.maxScrollExtent - scrollController.position.pixels < triggerDistance) {
      loadingFn();
    }
  }

  scrollController.addListener(checkDistance);
  return () => scrollController.removeListener(checkDistance);
}