import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/indexed_view.dart';
import 'package:moegirl_viewer/components/styled_widgets/circular_progress_indicator.dart';

class InfinityListFooter extends StatelessWidget {
  final num status;
  final String errorText;
  final String allLoadedText;
  final String emptyText;
  final EdgeInsets margin;
  final void Function() onReloadingButtonPrssed;

  const InfinityListFooter({
    @required this.status,
    this.errorText = '加载失败，点击重试',
    this.allLoadedText = '已经没有啦',
    this.emptyText = '该分类下暂无条目',
    this.margin = const EdgeInsets.only(top: 20, bottom: 20),
    @required this.onReloadingButtonPrssed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double fontSize = 16;
    
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