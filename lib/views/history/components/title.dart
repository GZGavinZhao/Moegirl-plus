// @dart=2.9
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';

class HistoryPageTitle extends StatelessWidget {
  final String text;
  
  const HistoryPageTitle({
    @required this.text,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return NightSelector(
      builder: (night) => (
        Container(
          margin: EdgeInsets.only(bottom: 1),
          padding: EdgeInsets.only(top: 5, bottom: 10),
          color: night ? Colors.transparent : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(text,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 16
                  ),
                ),
              ),

              Container(
                height: 2,
                margin: EdgeInsets.only(top: 3, right: 10),
                color: theme.colorScheme.secondary,
              )
            ],
          ),
        )
      ),
    );
  }
}