import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

class LoginPageStyledTextField extends StatefulWidget {
  final String labelText;
  final bool isPassword;
  final void Function(FocusNode) emitFocusNode;
  final void Function(String) onChanged;

  LoginPageStyledTextField({
    this.labelText,
    this.isPassword = false,
    this.emitFocusNode,
    this.onChanged,
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
          cursorColor: Colors.white,
          cursorHeight: 20,
          autofocus: false,
          focusNode: focusNode,
          onChanged: widget.onChanged,
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
        ),

        if (widget.isPassword) (
          Positioned(
            right: 5,
            top: 5,
            child: IconButton(
              onPressed: () => setState(() => showingPassword = !showingPassword),
              icon: Icon(showingPassword ? CommunityMaterialIcons.eye : CommunityMaterialIcons.eye_off),
              iconSize: 28,
              color: showingPassword ? Colors.green[100] : Colors.grey[200],
            ),
          )
        )
      ],
    );
  }
}