import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/database/category_search_history.dart';
import 'package:moegirl_plus/database/index.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
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
  List<CategorySearchHistory> searchingHistoryList = [];
  final textEditingController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    CategorySearchHistoryDbClient.getList().then((list) => setState(() => searchingHistoryList = list));
  }

  void clearHistoryList() async {
    final result = await showAlert(
      content: Lang.searchPage_recentSearch_delAllRecordCheck,
      visibleCloseButton: true
    );

    if (!result) return;
    setState(() => searchingHistoryList.clear());
    CategorySearchHistoryDbClient.clear();
  }

  void removeHistoryItem(CategorySearchHistory targetItem) async {
    final result = await showAlert(
      content: Lang.searchPage_recentSearch_delSingleRecordCheck,
      visibleCloseButton: true
    );

    if (!result) return;  
    setState(() => searchingHistoryList.removeWhere((listLtem) => listLtem.matchCategories(targetItem)));
    CategorySearchHistoryDbClient.remove(targetItem);
  }

  void addCategoryToList(String categoryName) {
    if (selectedCategoryList.contains(categoryName)) return toast(Lang.categorySearchPage_categoryDuplicateHint, position: ToastPosition.center);
    textEditingController.clear();
    setState(() {
      selectedCategoryList.add(categoryName);
      inputText = '';
    });
  }

  void removeCategoryFromList(String categoryName) {
    setState(() => selectedCategoryList = selectedCategoryList.where((item) => item != categoryName).toList());
  }

  void toSearchResult(List<String> selectedCategoryList) {
    if (selectedCategoryList.length == 0) return toast(Lang.categorySearchPage_categoryEmptyHint);

    final searchHistory = CategorySearchHistory.fromCategories(selectedCategoryList);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      setState(() {
        searchingHistoryList
          ..removeWhere((item) => item.matchCategories(searchHistory))
          ..insert(0, searchHistory);
      });
    });

    CategorySearchHistoryDbClient.add(searchHistory);

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
              value: inputText,
              categoryList: selectedCategoryList,
              textEditingController: textEditingController,
              onChanged: (text) => setState(() => inputText = text),
              onDeleteCategory: removeCategoryFromList,
              onSubmitted: () => toSearchResult(selectedCategoryList),
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            child: inputText == '' ? 
              CategorySearchPageRecentSearch(
                searchingHistoryList: searchingHistoryList,
                onPressed: (target) => toSearchResult(target.categories),
                onClearButtonPressed: clearHistoryList,
                onItemLongPressed: (target) => removeHistoryItem(target),
              ) :
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