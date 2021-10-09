// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/prefs/search.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/search/views/result/index.dart';
import 'package:one_context/one_context.dart';

class SearchPageAppBarBody extends StatefulWidget {
  final void Function(String) onChanged;

  SearchPageAppBarBody({
    Key key,
    @required this.onChanged
  }) : super(key: key);

  @override
  _SearchPageAppBarBodyState createState() => _SearchPageAppBarBodyState();
}

class _SearchPageAppBarBodyState extends State<SearchPageAppBarBody> {
  final editingController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    editingController.addListener(() => setState(() {}));
  }

  void clearInputText() {
    editingController.clear();
    widget.onChanged('');
  }

  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
  }

  void textFieldWasSubmitted(String keyword) {
    if (keyword.trim() == '') return toast(Lang.emptySearchKeywordHint);
    searchingHistoryPref.add(SearchingHistory(keyword, false));
    OneContext().pushNamed('/search/result', arguments: SearchResultPageRouteArgs(keyword: keyword));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NightSelector(
      builder: (isNight) => (
        Row(
          children: [            
            Expanded(
              child: Theme(
                data: theme.copyWith(brightness: Brightness.light),
                child: TextField(
                  autofocus: true,
                  cursorHeight: 22,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: RuntimeConstants.source == 'moegirl' ? Lang.searchInMoegirl : Lang.searchInMoegirl_h,
                    hintStyle: TextStyle(
                      color: isNight ? theme.colorScheme.onPrimary : theme.hintColor
                    )
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: isNight ? theme.colorScheme.onPrimary : theme.textTheme.bodyText1.color
                  ),
                  controller: editingController,
                  onChanged: widget.onChanged,
                  onSubmitted: textFieldWasSubmitted,
                ),
              ),
            ),

            if (editingController.text != '') (
              CupertinoButton(
                onPressed: clearInputText,
                child: Icon(Icons.close,
                  size: 20,
                  color: theme.disabledColor,
                ),
              )
            )
          ],
        )
      ),
    );
  }
}