// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/hover_bg_color_button.dart';

class QuickInsertingButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final void Function() onPressed;
  
  const QuickInsertingButton({
    this.title,
    this.icon,
    this.subtitle,
    @required this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return HoverBgColorButton(
      onPressed: onPressed,
      child: Container(
          height: 45,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 22,
                // padding: EdgeInsets.only(bottom: 2),
                alignment: Alignment.center,
                child: title != null ? 
                  Text(title,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.hintColor,
                      height: 1
                    ),
                  )
                :
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Icon(icon,
                      size: 22,  
                      color: theme.hintColor,
                    ),
                  )
                ,
              ),
              if (subtitle != null) (
                Container(
                  child: Text(subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      color: theme.hintColor,
                    ),
                  ),
                )
              )
            ],
          ),
        ),
    );
  }
}