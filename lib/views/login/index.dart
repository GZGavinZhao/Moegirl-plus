import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/login/components/styled_text_field.dart';
import 'package:one_context/one_context.dart';
import 'package:url_launcher/url_launcher.dart';

const moegirlCreateAccountPageUrl = 'https://mzh.moegirl.org.cn/index.php?title=Special:创建账户';
const hmoeCreateAccountPageUrl = 'https://www.hmoegirl.com/index.php?title=%E7%89%B9%E6%AE%8A:%E5%88%9B%E5%BB%BA%E8%B4%A6%E6%88%B7&returnto=Mainpage';

class LoginPageRouteArgs {
  
  LoginPageRouteArgs();
}

class LoginPage extends StatefulWidget {
  final LoginPageRouteArgs routeArgs;
  LoginPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName = '';
  String password = '';
  FocusNode userNameInputFucusNode;
  FocusNode passwordInputFocusNode;

  void submit() {
    userNameInputFucusNode.unfocus();
    passwordInputFocusNode.unfocus();
    if (userName.trim() == '') return toast(Lang.userNameEmptyHint, position: ToastPosition.center);
    if (password.trim() == '') return toast(Lang.passwordEmptyHint, position: ToastPosition.center);

    showLoading(text: Lang.logging);
    accountProvider.login(userName, password)
      .whenComplete(OneContext().pop)
      .then((loginResult) {
        if (loginResult.successed) {
          toast(Lang.loggedIn, position: ToastPosition.center);
          OneContext().pop();
        } else {
          toast(loginResult.message);
        }
      })
      .catchError((err) {
        print(err);
        toast(Lang.netErr);
      });
  }

  @override
  Widget build(BuildContext context) {
    AppBar(systemOverlayStyle: SystemUiOverlayStyle.light,);
    
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/${RuntimeConstants.source}/login_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(RuntimeConstants.source == 'moegirl' ? 0.5 : 0.3), BlendMode.darken)
          )
        ),
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/${RuntimeConstants.source}/moemoji.png', width: 70, height: 70),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(RuntimeConstants.source == 'moegirl' ? Lang.moegirlSloganText : Lang.moegirlSloganText_h,
                  style: TextStyle(
                    color: RuntimeConstants.source == 'moegirl' ? Colors.green[100] : Color(0xffFFE686),
                    fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LoginPageStyledTextField(
                  labelText: Lang.userName,
                  emitFocusNode: (focusNode) => userNameInputFucusNode = focusNode,
                  onChanged: (text) => setState(() => userName = text),
                  onSubmitted: () => passwordInputFocusNode.requestFocus(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LoginPageStyledTextField(
                  labelText: Lang.password,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  emitFocusNode: (focusNode) => passwordInputFocusNode = focusNode,
                  onChanged: (text) => setState(() => password = text),
                  onSubmitted: submit
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 300,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(RuntimeConstants.source == 'moegirl' ? Colors.green : Color(0xffFFE686)),
                      elevation: MaterialStateProperty.all(0)
                    ),
                    child: Text(Lang.login, 
                      style: TextStyle(
                        fontSize: 18,
                        color: RuntimeConstants.source == 'moegirl' ? Colors.white : Colors.black
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: CupertinoButton(
                  onPressed: () => launch(RuntimeConstants.source == 'moegirl' ? moegirlCreateAccountPageUrl : hmoeCreateAccountPageUrl),
                  child: Text(RuntimeConstants.source == 'moegirl' ? Lang.noAccountHint : Lang.noAccountHint_h,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      decoration: TextDecoration.underline
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}