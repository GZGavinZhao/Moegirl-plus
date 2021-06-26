import 'dart:async';

final Map<Function, Timer> _timerCaches = {};

typedef DebouncedFunc = dynamic Function(dynamic args);

// 函数防抖化，每次传入的函数必须指向的是同一地址
T debounce<T extends DebouncedFunc>(T func, [Duration duration = const Duration(milliseconds: 500)]) {
  final T debouncedFunc = (dynamic args) {
    _timerCaches[func]?.cancel();
    final timer = Timer(duration, () => func(args));
    _timerCaches[func] = timer;
  } as DebouncedFunc;
  
  return debouncedFunc;
}