// @dart=2.9
import 'package:flutter/material.dart';

void Function() addInfinityListLoadingListener(
  ScrollController scrollController, 
  void Function() loadingFn,
  [double triggerDistance = 100]
) {
  checkDistance() async {
    double bottomOfDistance = scrollController.position.maxScrollExtent - scrollController.position.pixels;
    if (bottomOfDistance < triggerDistance) {
      loadingFn();
    }
  }

  scrollController.addListener(checkDistance);
  return () => scrollController.removeListener(checkDistance);
}