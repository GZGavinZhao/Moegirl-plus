// @dart=2.9
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final double size;
  final String text;
  
  const Badge({
    this.size = 7.0,
    this.text,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerWidth = 8;
    double containerHeight = 8;
    
    if (text != null) {
      // 在有文字的情况下，一个文字时大小为14，此后每再有一个文字，加(文字数量 * 文字大小 / 2)，因为数字是半角符号
      containerWidth = containerHeight = 14;
      containerWidth += (text.length - 1) * 5;  // 
    }
    
    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(Radius.circular(containerHeight / 2))
      ),
      alignment: Alignment.center,
      child: text != null ?
        Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            height: 1.3
          ),
        )
      : null
    );
  }
}