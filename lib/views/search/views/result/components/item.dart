import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/language/index.dart';

class SearchResultItem extends StatelessWidget {
  final Map data;
  final String keyword;
  final void Function(String pageName) onPressed;

  const SearchResultItem({
    @required this.data,
    @required this.keyword,
    @required this.onPressed,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                  style: TextStyle(backgroundColor: theme.primaryColorLight),
                  text: strong,
                ),
                if (plain != null) TextSpan(text: plain)
              ]
            )
          );
        })
        .values.toList();
    }

    final String subInfoText = (() {
      var text = '';
      if (data.containsKey('redirecttitle')) {
        text = Lang.searchResultPage_item_redirectTitle(data['redirecttitle']);
      } else if (data.containsKey('sectiontitle')) {
        text = Lang.searchResultPage_item_sectionTitle(keyword);
      } else if (data.containsKey('categoriesnippet')) {
        text = '${Lang.searchResultPage_item_foundFromCategories}：${data['categoriesnippet']}';
      }

      return text;
    })();

    final content = contentFormat(data['snippet']);

    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: theme.shadowColor.withOpacity(0.2),
          offset: Offset(0, 1),
          blurRadius: 2,
        )]
      ),
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          splashColor: theme.primaryColorLight.withOpacity(0.2),
          highlightColor: theme.primaryColorLight.withOpacity(0.1),
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
                    Expanded(
                      child: Text(subInfoText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontStyle: FontStyle.italic
                        ),
                      )
                    )
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: theme.accentColor, width: 2),
                      bottom: BorderSide(color: theme.accentColor, width: 2)
                    )
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyText1.merge(TextStyle(
                        height: 1.3
                      )),
                      children: content ?? [TextSpan(
                        text: Lang.searchResultPage_item_noContent,
                        style: TextStyle(color: theme.hintColor)
                      )]
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatDate(
                      DateTime.parse(data['timestamp']), 
                      Lang.searchResultPage_item_dateFormat
                    ),
                    style: TextStyle(color: theme.hintColor),
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