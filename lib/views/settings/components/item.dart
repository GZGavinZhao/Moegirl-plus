import 'package:flutter/material.dart';

class SettingsPageItem extends StatelessWidget {
  final String title;
  final String subtext;
  final Widget rightWidget;
  final void Function() onPressed;

  SettingsPageItem({
    @required this.title,
    this.subtext,
    this.rightWidget,
    this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
       child: InkWell(
         onTap: onPressed,
         child: Container(
           padding: EdgeInsets.all(15),
           decoration: BoxDecoration(
             border: Border(bottom: BorderSide(color: theme.dividerColor))
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(title,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodyText1.color
                      )
                   ),
                   if (subtext != null) (
                     Padding(
                       padding: EdgeInsets.only(top: 5),
                       child: Text(subtext,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.hintColor
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
              rightWidget ?? Container(width: 0, height: 0)
             ],
           ),
         ),
       ),
    );
  }
}