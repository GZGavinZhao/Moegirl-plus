import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/search.dart';
import 'package:moegirl_viewer/components/styled/circular_progress_indicator.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:one_context/one_context.dart';

import 'components/item.dart';

class SearchResultPageRouteArgs {
  final String keyword;

  SearchResultPageRouteArgs({
    @required this.keyword
  });
}

class SearchResultPage extends StatefulWidget {
  final SearchResultPageRouteArgs routeArgs;
  SearchResultPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List resultList = [];
  int resultTotal;
  int status = 1;
  final scrollController = ScrollController();

  @override
  void initState() { 
    super.initState();
    loadList();

    // 监听滚动，进行上拉加载
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - scrollController.position.pixels < 100) {
        loadList();
      }
    });
  }

  @override
  void dispose() { 
    scrollController.dispose();
    super.dispose();
  }

  void loadList() async {
    if ([4, 2].contains(status)) return;
    setState(() => status = 2);

    try {
      final data = await SearchApi.search(widget.routeArgs.keyword, resultList.length);
      if (data['query']['searchinfo']['totalhits'] == 0) {
        setState(() => status = 5);
        return;
      }

      var nextStatus = 3;
      if (data['query']['searchinfo']['totalhits'] == resultList.length + data['query']['search'].length) {
        nextStatus = 4;
      }

      setState(() {
        resultTotal = data['query']['searchinfo']['totalhits'];
        resultList.addAll(data['query']['search']);
        status = nextStatus;
      });
    } catch(e) {
      print('加载搜索结果失败');
      print(e);
      setState(() => status = 0);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: theme.backgroundColor,
        elevation: 3,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: theme.hintColor,
          iconSize: 26,
          splashRadius: 20,
          onPressed: () => OneContext().pop(),
        ),
        title: Text('搜索：${widget.routeArgs.keyword}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.hintColor
          ),
        ),
      ),

      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 10),
          itemCount: resultList.length + 2,
          controller: scrollController,
          itemBuilder: (context, index) {
            // 头部
            if (index == 0) {
              if (status != 3) return Container(width: 0, height: 0);
              return Padding(
                padding: EdgeInsets.only(top: 10, bottom: 3, left: 10, right: 10),
                // ignore: unnecessary_brace_in_string_interps
                child: Text('共搜索到${resultTotal}条结果。',
                  style: TextStyle(
                    color: theme.hintColor
                  ),
                ),
              );
            }
            
            // 尾部
            if (index == resultList.length + 1) {
              if (status == 2) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15, bottom: 5),
                  child: StyledCircularProgressIndicator(),
                );
              }

              if (status == 0) {
                return Container(
                  child: CupertinoButton(
                    onPressed: loadList,
                    child: Text('加载失败，点击重试',
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ),
                );
              }

              if (status == 4) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15, bottom: 5),
                  child: Text('已经没有啦',
                    style: TextStyle(color: theme.disabledColor),
                  ),
                );
              }

              return Container(width: 0, height: 0);
            }

            // item
            final itemData = resultList[index - 1];
            return SearchResultItem(
              key: Key(itemData['title']),
              data: itemData,
              keyword: widget.routeArgs.keyword,
              onPressed: (pageName) => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: pageName)),
            );
          }
        )
      )
    );
  }
}