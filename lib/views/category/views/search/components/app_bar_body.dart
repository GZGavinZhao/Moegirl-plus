import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';

class CategorySearchPageAppBarBody extends StatefulWidget {
  final List<String> categoryList;  // 传入分类列表时，为分类搜索
  final void Function(String) onChanged;
  final void Function() onSubmitted;
  final void Function(String categoeyName) onSelectedCategoryPressed;

  CategorySearchPageAppBarBody({
    this.categoryList,
    Key key,
    @required this.onChanged,
    @required this.onSubmitted,
    @required this.onSelectedCategoryPressed,
  }) : super(key: key);

  @override
  _CategorySearchPageAppBarBodyState createState() => _CategorySearchPageAppBarBodyState();
}

class _CategorySearchPageAppBarBodyState extends State<CategorySearchPageAppBarBody> {
  final inputContainerKey = GlobalKey();
  double get inputContainerWidth => inputContainerKey.currentContext?.findRenderObject()?.semanticBounds?.width ?? 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 

    return NightSelector(
      builder: (isNight) => (
        SingleChildScrollView(
          key: inputContainerKey,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [                   
              for (final item in widget.categoryList) (
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: TouchableOpacity(
                    onPressed: () => widget.onSelectedCategoryPressed(item),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Text(Lang.category + ':' + item,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onPrimary
                        ),
                      ),
                    ),
                  ),
                )
              ),

              SizedBox(
                width: inputContainerWidth,
                child: TextField(
                  autofocus: true,
                  cursorHeight: 22,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '搜索分类...',
                    hintStyle: TextStyle(
                      color: isNight ? theme.colorScheme.onPrimary : theme.hintColor
                    )
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: isNight ? theme.colorScheme.onPrimary : theme.textTheme.bodyText1.color
                  ),
                  onChanged: widget.onChanged,
                  onSubmitted: (_) => widget.onSubmitted(),
                ),
              )
            ]
          ),
        )
      )
    );
  }
}