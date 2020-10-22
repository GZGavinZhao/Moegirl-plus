import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moegirl_viewer/views/history/index.dart';

class HistoryPageItem extends StatelessWidget {
  final ReadingHistoryWithDisplayDate data;
  final void Function(String pageName) onPressed;
  
  const HistoryPageItem({
    this.data,
    this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(1)),
        boxShadow: [BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 1),
          blurRadius: 2,
        )]
      ),
      child: Material(
        child: InkWell(
          highlightColor: Color(0xffeeeeee),
          splashColor: Colors.green[100],
          onTap: () => onPressed(data.pageName),
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: (14 * 15).toDouble(),
                  padding: EdgeInsets.only(left: 5),
                  child: Text(data.displayPageName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                Positioned(
                  top: 5,
                  left: 0,
                  child: data.imgPath != null ? 
                    Image.file(File(data.imgPath),
                      width: 60,
                      height: 70,
                    )
                  :
                    Image.asset('assets/images/moemoji.png',
                      width: 60,
                      height: 70,
                    )
                ),

                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Text(data.displayDate)
                )
              ]
            )
          )
        ),
      ),
    );
  }
}