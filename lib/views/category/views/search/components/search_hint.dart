import 'package:flutter/material.dart';
import 'package:moegirl_plus/api/search.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/media_wiki_namespace.dart';

class SrarchPageSearchHint extends StatefulWidget {
  final String keyword;
  final void Function(String categoryName) onHintPressed;

  SrarchPageSearchHint({
    @required this.keyword,
    @required this.onHintPressed,
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
      final hintData = await SearchApi.getHint(widget.keyword, namespace: MediaWikiNamespace.category);
      setState(() {
        status = 3;
        hintList = hintData['query']['search']
          .map((item) => item['title'].replaceFirst('Category:', ''))
          .cast<String>()
          .toList();
      });
    } catch(e) {
      print('加载搜索提示失败');
      print(e);
      setState(() => status = 0);
    }
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

    if (status == 0) return listItem(Lang.loadFail);
    if (status == 2) return listItem(Lang.loading + '...');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: hintList.map((item) =>
          InkWell(
            onTap: () => widget.onHintPressed(item),
            child: listItem(item),
          )
        ).toList(),
      )
    );
  }
}