import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';

class CategorySearchPageAppBarBody extends StatefulWidget {
  final List<String> categoryList;
  final String value;
  final TextEditingController textEditingController;
  final void Function(String) onChanged;
  final void Function() onSubmitted;
  final void Function(String categoeyName) onDeleteCategory;

  CategorySearchPageAppBarBody({
    @required this.categoryList,
    @required this.value,
    this.textEditingController,
    @required this.onChanged,
    @required this.onSubmitted,
    @required this.onDeleteCategory,
    Key key,
  }) : super(key: key);

  @override
  _CategorySearchPageAppBarBodyState createState() => _CategorySearchPageAppBarBodyState();
}

class _CategorySearchPageAppBarBodyState extends State<CategorySearchPageAppBarBody> {
  final inputContainerKey = GlobalKey();
  double get inputContainerWidth => inputContainerKey.currentContext?.findRenderObject()?.semanticBounds?.width ?? 0;

  @override
  void initState() { 
    super.initState();

    // inputContainerKey首次渲染拿不到高度，这里手动再触发一次渲染
    Future.microtask(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 

    return NightSelector(
      builder: (isNight) => (
        Container(
          key: inputContainerKey,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: [                   
                for (final item in widget.categoryList) (
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: TouchableOpacity(
                      onPressed: () => widget.onDeleteCategory(item),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Text(item,
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
                    controller: widget.textEditingController,
                    autofocus: true,
                    cursorHeight: 22,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Lang.categorySearchPage_appBarBody_placeholder,
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
          ),
        )
      )
    );
  }
}