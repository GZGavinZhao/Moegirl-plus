import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LoginPageStyledTextField extends StatefulWidget {
  final String labelText;
  final bool isPassword;
  final TextInputAction textInputAction;
  final void Function(FocusNode) emitFocusNode;
  final void Function(String) onChanged;
  final void Function() onSubmitted;

  LoginPageStyledTextField({
    @required this.labelText,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
    @required this.emitFocusNode,
    @required this.onChanged,
    this.onSubmitted,
    Key key,
  }) : super(key: key);

  @override
  _LoginPageStyledTextFieldState createState() => _LoginPageStyledTextFieldState();
}

class _LoginPageStyledTextFieldState extends State<LoginPageStyledTextField> {
  final focusNode = FocusNode();
  bool showingPassword = false;

  @override
  void initState() { 
    super.initState();
    focusNode.addListener(() => setState(() {}));
    widget.emitFocusNode(focusNode);
  }

  @override
  void dispose() { 
    focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          focusNode: focusNode,
          cursorColor: Colors.white,
          cursorHeight: 20,
          autofocus: false,
          textInputAction: widget.textInputAction,
          obscureText: widget.isPassword && !showingPassword,
          keyboardType: widget.isPassword ? TextInputType.visiblePassword : null,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: focusNode.hasFocus ? Colors.green[100] : Colors.grey[100],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.grey[100],
                width: 1,
                style: BorderStyle.solid
              )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.green[100],
                width: 3
              )
            ),
          ),
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onSubmitted(),
        ),

        if (widget.isPassword) (
          Positioned(
            right: 5,
            top: 5,
            child: IconButton(
              onPressed: () => setState(() => showingPassword = !showingPassword),
              icon: Icon(showingPassword ? MaterialCommunityIcons.eye : MaterialCommunityIcons.eye_off),
              iconSize: 28,
              color: showingPassword ? Colors.green[100] : Colors.grey[200],
            ),
          )
        )
      ],
    );
  }
}