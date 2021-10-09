// @dart=2.9
import 'package:flutter/material.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/views/history/index.dart';

class HistoryPageItem extends StatelessWidget {
  final ReadingHistoryWithDisplayDate data;
  final void Function(String pageName) onPressed;
  
  const HistoryPageItem({
    @required this.data,
    @required this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 90,
      margin: EdgeInsets.only(bottom: 1),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.all(Radius.circular(1)),
      //   boxShadow: [BoxShadow(
      //     color: theme.shadowColor.withOpacity(0.2),
      //     offset: Offset(0, 1),
      //     blurRadius: 2,
      //   )]
      // ),
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          splashColor: theme.primaryColorLight,
          highlightColor: theme.primaryColorLight.withOpacity(0.5),
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
                  top: data.image != null ? 0 : 5,
                  left: data.image != null ? 0 : 5,
                  child: data.image != null ? 
                    Image.memory(data.image,
                      width: 70,
                      height: 90,
                      fit: BoxFit.contain,
                    )
                  :
                    Image.asset('assets/images/${RuntimeConstants.source}/moemoji.png',
                      width: 60,
                      height: 80,
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