import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/category/index.dart';
import 'package:moegirl_plus/views/category/views/search/components/app_bar_body.dart';
import 'package:moegirl_plus/views/category/views/search/components/recent_search.dart';
import 'package:one_context/one_context.dart';

import 'components/search_hint.dart';

class CategorySearchPageRouteArgs {
  final String keyword;
  
  CategorySearchPageRouteArgs({
    @required this.keyword
  });
}

class CategorySearchPage extends StatefulWidget {
  final CategorySearchPageRouteArgs routeArgs;

  CategorySearchPage(this.routeArgs, {Key key}) : super(key: key);

  @override
  _CategorySearchPageState createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends State<CategorySearchPage> {
  String inputText = '';
  List<String> selectedCategoryList = [];

  void addCategoryToList(String categoryName) {
    if (selectedCategoryList.contains(categoryName)) return toast('请勿重复添加分类', position: ToastPosition.center);
    setState(() => selectedCategoryList.add(categoryName));
  }

  void removeCategoryFromList(String categoryName) {
    setState(() => selectedCategoryList = selectedCategoryList.where((item) => item != categoryName).toList());
  }

  void toSearchResult() {
    if (selectedCategoryList.length == 0) return toast('请选择要搜索的分类');
    OneContext().pushNamed('/category', arguments: CategoryPageRouteArgs(
      categoryList: selectedCategoryList
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);    
    return NightSelector(
      builder: (isNight) => (
        Scaffold(
          appBar: AppBar(
            brightness: isNight ? Brightness.dark : Brightness.light,
            backgroundColor: isNight ? theme.primaryColor : Colors.white,
            elevation: 3,
            leading: AppBarBackButton(
              color: isNight ? theme.colorScheme.onPrimary : theme.hintColor,
            ),
            title: CategorySearchPageAppBarBody(
              categoryList: selectedCategoryList,
              onChanged: (text) => setState(() => inputText = text),
              onDeleteCategory: removeCategoryFromList,
              onSubmitted: toSearchResult,
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            child: inputText == '' ? 
              CategorySearchPageRecentSearch() :
              SrarchPageSearchHint(
                keyword: inputText,
                onHintPressed: addCategoryToList,
              ),
          )
        )
      )
    );
  }
}