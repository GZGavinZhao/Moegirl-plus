import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:moegirl_viewer/prefs/search.dart';
import 'package:moegirl_viewer/utils/ui/dialog/index.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';
import 'package:vibration/vibration.dart';

class SearchPageRecentSearch extends StatefulWidget {
  SearchPageRecentSearch({Key key}) : super(key: key);

  @override
  _SearchPageRecentSearchState createState() => _SearchPageRecentSearchState();
}

class _SearchPageRecentSearchState extends State<SearchPageRecentSearch> {
  List<SearchingHistory> get searchingHistoryList => searchingHistoryPref.getList();

  @override
  void initState() { 
    super.initState();
  }

  void removeItem(String keyword) async {
    Vibration.vibrate();
    final result = await CommonDialog.alert(
      content: '确定要删除这条搜索记录吗？',
      visibleCloseButton: true
    );

    if (!result) return;
    searchingHistoryPref.remove(keyword);
    setState(() {});
  }

  void clearList() async {
    final result = await CommonDialog.alert(
      content: '确定要删除全部搜索记录吗？',
      visibleCloseButton: true
    );

    if (!result) return;
    searchingHistoryPref.clear();
    setState(() {});
  }

  void itemWasPressed(SearchingHistory item) {
    searchingHistoryPref.add(item);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      setState(() {});
    });
    
    if (item.byHint) {
      OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
        pageName: item.keyword
      ));
    } else {
      // goto search result
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (searchingHistoryList.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text('暂无搜索记录',
          style: TextStyle(
            color: Color(0xffcccccc),
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
              Text('最近搜索',
                style: TextStyle(
                  color: Color(0xff666666),
                ),
              ),

              IconButton(
                icon: Icon(Icons.delete),
                iconSize: 20,
                color: Color(0xffababab),
                splashRadius: 18,
                onPressed: clearList,
              )
            ],
          ),
        ),

        SingleChildScrollView(
          child: Column(
            children: searchingHistoryList.map<Widget>((item) =>
              InkWell(
                onTap: () => itemWasPressed(item),
                onLongPress: () => removeItem(item.keyword),
                child: Container(
                  height: 42,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffcccccc),
                        width: 1
                      )
                    )
                  ),
                  child: Text(item.keyword,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xff666666)
                    ),
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