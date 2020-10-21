import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  final Map data;
  final String keyword;
  final void Function(String pageName) onPressed;

  const SearchResultItem({
    @required this.data,
    @required this.keyword,
    this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> contentFormat(String content) {
      if (content.trim() == '') return null;

      return content
        .split('<span class="searchmatch">')
        .asMap()
        .map((index, section) {
          if (index == 0) return MapEntry(index, TextSpan(text: section));
          final foo = section.split('</span>');
          final strong = foo[0];
          final plain = foo[1];

          return MapEntry(index,
            TextSpan(
              children: [
                TextSpan(
                  style: TextStyle(backgroundColor: Color(0xffB5E9B5)),
                  text: strong,
                ),
                if (plain != null) TextSpan(text: plain)
              ]
            )
          );
        })
        .values.toList();
    }

    final Widget subInfo = (() {
      var text = '';
      if (data.containsKey('redirecttitle')) {
        text = '「${data['redirecttitle']}」指向该页面';
      } else if (data.containsKey('sectiontitle')) {
        text = '该页面有名为“$keyword”的章节';
      } else if (data.containsKey('categoriesnippet')) {
        text = '匹配自页面分类：${data['categoriesnippet']}';
      }

      return Text(text,
        style: TextStyle(
          color: Colors.green,
          fontStyle: FontStyle.italic
        ),
      );
    })();

    final content = contentFormat(data['snippet']);

    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 1),
          blurRadius: 2,
        )]
      ),
      child: Material(
        child: InkWell(
          splashColor: Colors.green[100],
          highlightColor: Color(0xffeeeeee),
          onTap: () => onPressed(data['title']),
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    ),
                    subInfo
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.green, width: 2),
                      bottom: BorderSide(color: Colors.green, width: 2)
                    )
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: content ?? [TextSpan(
                        text: '页面内貌似没有内容呢...',
                        style: TextStyle(color: Color(0xff666666))
                      )]
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatDate(
                      DateTime.parse(data['timestamp']), 
                      ['最后更新于：', yyyy, '年', mm, '月', dd, '日']
                    ),
                    style: TextStyle(color: Color(0xff666666)),
                  ),
                )
              ],
            )
          )
        ),
      ),
    );
  }
}