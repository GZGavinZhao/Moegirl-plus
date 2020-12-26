import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:one_context/one_context.dart';

class CategoryPageSubCategoryList extends StatefulWidget {
  final bool visibleLoadMoreButton;
  final bool visibleLoadingIndicator;
  final List<String> subCategoryList;
  final void Function() onLoadMoreButtonPressed;
  
  CategoryPageSubCategoryList({
    this.visibleLoadMoreButton = false,
    this.visibleLoadingIndicator = false,
    @required this.subCategoryList,
    this.onLoadMoreButtonPressed,
    Key key
  }) : super(key: key);

  @override
  _CategoryPageSubCategoryListState createState() => _CategoryPageSubCategoryListState();
}

class _CategoryPageSubCategoryListState extends State<CategoryPageSubCategoryList> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: theme.backgroundColor,
        elevation: 1,
        child: Column(
          children: [
            // header
            Container(
              height: 40,
              padding: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('子分类列表',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.hintColor
                    ),
                  ),

                  Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                      padding: EdgeInsets.all(10),
                      iconSize: 20,
                      color: theme.hintColor,
                      splashRadius: 10,
                      onPressed: () => setState(() => isExpanded = !isExpanded),
                    ),
                  )
                ],
              ),
            ),

            // body
            if (isExpanded) (
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme.dividerColor))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.subCategoryList.map((categoryName) =>
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.5),
                        child: TouchableOpacity(
                          onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                            pageName: 'Category:$categoryName'
                          )),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 4.5, right: 5),
                                    child: Icon(Icons.lens,
                                      color: theme.disabledColor,
                                      size: 8,
                                    ),
                                  )
                                ),
                                TextSpan(
                                  text: categoryName,
                                  style: TextStyle(
                                    color: theme.accentColor,
                                    fontSize: 15
                                  ),
                                )
                              ]
                            ),
                          ),
                        ),
                      )
                    ),

                    if (widget.visibleLoadMoreButton) (
                      Center(
                        child: CupertinoButton(
                          minSize: 0,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          onPressed: widget.onLoadMoreButtonPressed,
                          child: Text('加载更多',
                            style: TextStyle(
                              color: theme.hintColor,
                              fontSize: 14
                            ),
                          ),
                        ),
                      )
                    ),

                    if (widget.visibleLoadingIndicator) (
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: StyledCircularProgressIndicator(),
                        ),
                      )
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}