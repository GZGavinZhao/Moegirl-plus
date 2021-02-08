import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/database/category_search_history.dart';
import 'package:moegirl_plus/language/index.dart';

class CategorySearchPageRecentSearch extends StatefulWidget {
  final List<CategorySearchHistory> searchingHistoryList;
  final void Function(CategorySearchHistory targetItem) onItemLongPressed;
  final void Function() onClearButtonPressed;
  final void Function(CategorySearchHistory history) onPressed;

  CategorySearchPageRecentSearch({
    @required this.searchingHistoryList,
    @required this.onItemLongPressed,
    @required this.onClearButtonPressed,
    @required this.onPressed,
    Key key
  }) : super(key: key);

  @override
  _CategorySearchPageRecentSearchState createState() => _CategorySearchPageRecentSearchState();
}

class _CategorySearchPageRecentSearchState extends State<CategorySearchPageRecentSearch> {  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.searchingHistoryList.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text(Lang.searchPage_recentSearch_noData,
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 18
          ),
        ),
      );
    }
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Lang.searchPage_recentSearch_title,
                style: TextStyle(
                  color: theme.hintColor,
                ),
              ),

              IconButton(
                icon: Icon(Icons.delete),
                iconSize: 20,
                color: theme.disabledColor,
                splashRadius: 18,
                onPressed: widget.onClearButtonPressed,
              )
            ],
          ),
        ),

        SingleChildScrollView(
          child: Column(
            children: widget.searchingHistoryList.map<Widget>((historyItem) =>
              InkWell(
                onTap: () => widget.onPressed(historyItem),
                onLongPress: () => widget.onItemLongPressed(historyItem),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerColor,
                        width: 1
                      )
                    )
                  ),
                  child: Row(
                    children: [
                      for (final categoryItem in historyItem.categories) (
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Text(categoryItem,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onPrimary
                              ),
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                )
              )
            ).toList(),
          ),
        )
      ],
    );
  }
}