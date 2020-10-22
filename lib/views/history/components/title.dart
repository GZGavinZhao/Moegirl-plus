import 'package:flutter/material.dart';

class HistoryPageTitle extends StatelessWidget {
  final String text;
  
  const HistoryPageTitle({
    this.text,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(text,
              style: TextStyle(
                color: Colors.green,
                fontSize: 16
              ),
            ),
          ),

          Container(
            height: 2,
            margin: EdgeInsets.only(top: 3, right: 10),
            color: Colors.green,
          )
        ],
      ),
    );
  }
}