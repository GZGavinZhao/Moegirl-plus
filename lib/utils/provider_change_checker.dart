// @dart=2.9
import 'package:flutter/cupertino.dart';

mixin ProviderChangeChecker<T extends StatefulWidget> on State<T> {
  final Set<Function> _removeListenerFunctions = {};
  final Map<Function, dynamic> _prevValues = {};
  
  void addChangeChecker<T_Provider extends ChangeNotifier, T_Value>({
    @required T_Provider provider,
    @required T_Value Function(T_Provider provider) selector,
    @required void Function(T_Value value) handler,
    bool Function(T_Value prevVal, T_Value newVal) shouldExec
  }) {
    void listener() {
      final prevVal = _prevValues[selector];
      final newVal = selector(provider);

      final shouldExecuteHandler = shouldExec != null ? shouldExec(prevVal, newVal) : prevVal != newVal;
      if (shouldExecuteHandler) handler(newVal);
      _prevValues[selector] = newVal;
    }

    provider.addListener(listener);
    _prevValues[selector] = selector(provider); // 注册listener时就执行一次，防止第一次对比值为null
    _removeListenerFunctions.add(() => provider.removeListener(listener));
  }

  @override
  void dispose() { 
    _removeListenerFunctions.forEach((item) => item());
    super.dispose();
  }
}