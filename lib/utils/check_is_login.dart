// @dart=2.9
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:one_context/one_context.dart';

// 这个函数的用法是在其他方法中使用async，在方法顶部使用函数，利用抛出错误直接退出方法，防止未登录执行后续代码
Future<void> checkIsLogin(String message) async {
  if (!accountProvider.isLoggedIn) {
    final result = await showAlert<bool>(
      content: message,
      visibleCloseButton: true
    );

    if (result) {
      OneContext().pushNamed('/login');
      throw NotLoggedInError(true);
    } else {
      throw NotLoggedInError(false);
    }    
  }
} 

class NotLoggedInError implements Exception {
  final bool gotoLoginPressed;

  NotLoggedInError(this.gotoLoginPressed);
  
  @override
  String toString() => '未登录拦截：${gotoLoginPressed ? '点击前往登录' : '取消前往登录'}';
}