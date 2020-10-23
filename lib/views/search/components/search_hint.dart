import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/search.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:moegirl_viewer/prefs/search.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';

class SrarchPageSearchHint extends StatefulWidget {
  final String keyword;
  SrarchPageSearchHint({
    this.keyword,
    Key key
  }) : super(key: key);

  @override
  _SrarchPageSearchHintState createState() => _SrarchPageSearchHintState();
}

class _SrarchPageSearchHintState extends State<SrarchPageSearchHint> {
  List<String> hintList = [];
  int status = 1;

  @override
  void initState() { 
    super.initState();
    loadHintList();
  }

  @override
  void didUpdateWidget(covariant SrarchPageSearchHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyword == '') return;
    if (oldWidget.keyword != widget.keyword) loadHintList();
  }

  void loadHintList() async {
    try {
      setState(() => status = 2);
      final hintData = await SearchApi.getHint(widget.keyword);
      setState(() {
        status = 3;
        hintList = hintData['query']['search']
          .map((item) => item['title'])
          .cast<String>()
          .toList();
      });
    } catch(e) {
      print('加载搜索提示失败');
      print(e);
      setState(() => status = 0);
    }
  }

  void hintWasPressed(String pageName) {
    OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: pageName));
    searchingHistoryPref.add(SearchingHistory(pageName, true));
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget listItem(String text) {
      return Container(
        height: 42,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1
            )
          )
        ),
        child: Text(text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.hintColor
          ),
        ),
      );
    }

    if (status == 0) return listItem('加载失败');
    if (status == 2) return listItem('加载中...');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: hintList.map((item) =>
          InkWell(
            onTap: () => hintWasPressed(item),
            child: listItem(item),
          )
        ).toList(),
      )
    );
  }
}