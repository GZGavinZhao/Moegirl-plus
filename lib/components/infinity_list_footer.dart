// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/indexed_view.dart';
import 'package:moegirl_plus/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_plus/language/index.dart';

// ignore: must_be_immutable
class InfinityListFooter extends StatelessWidget {
  final num status;
  String errorText;
  String allLoadedText;
  String emptyText;
  final EdgeInsets margin;
  final void Function() onReloadingButtonPrssed;

  InfinityListFooter({
    @required this.status,
    this.errorText,
    this.allLoadedText,
    this.emptyText,
    this.margin = const EdgeInsets.only(top: 20, bottom: 20),
    @required this.onReloadingButtonPrssed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double fontSize = 16;

    errorText ??= Lang.loadErrToClickRetry;
    allLoadedText ??= Lang.noMore;
    emptyText ??= Lang.noData;
    
    return IndexedView(
      index: status,
      builders: {
        2: () => Container(
          alignment: Alignment.center,
          margin: margin,
          child: StyledCircularProgressIndicator(),
        ),

        0: () => Container(
          child: CupertinoButton(
            onPressed: onReloadingButtonPrssed,
            child: Text(errorText,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: fontSize
              ),
            ),
          ),
        ),

        4: () => Container(
          alignment: Alignment.center,
          margin: margin,
          child: Text(allLoadedText,
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: fontSize
            ),
          ),
        ),

        5: () => Container(
          alignment: Alignment.center,
          margin: margin,
          child: Text(emptyText,
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: fontSize
            ),
          ),
        )
      },
    );
  }
}