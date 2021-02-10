import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/api/category.dart';
import 'package:moegirl_plus/components/infinity_list_footer.dart';
import 'package:moegirl_plus/components/list_layout_with_movable_header/index.dart';
import 'package:moegirl_plus/components/structured_list_view.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/utils/add_infinity_list_loading_listener.dart';
import 'package:moegirl_plus/utils/status_bar_height.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:one_context/one_context.dart';

import 'components/item.dart';
import 'components/sub_category_list.dart';

class CategoryPageRouteArgs {
  final String categoryName;
  final List<String> categoryList;  // 传入这个代表为多分类搜索
  final List<String> parentCategories;
  final String categoryExplainPageName;
  
  CategoryPageRouteArgs({
    this.categoryName,
    this.categoryList,
    this.parentCategories,
    this.categoryExplainPageName
  });
}

class CategoryPage extends StatefulWidget {
  final CategoryPageRouteArgs routeArgs;
  CategoryPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AfterLayoutMixin {
  final subCategoryList = <String>[];
  int subCategoryListStatus = 1;
  String subCategoryListContinueKey;

  // 接口用第一个分类去查，如果是多分类，再用后几个分类去过滤
  bool get isMultiple => widget.routeArgs.categoryList != null && widget.routeArgs.categoryList.length > 1;
  String get firstCategoryName => 
    widget.routeArgs.categoryList != null ? widget.routeArgs.categoryList[0] : widget.routeArgs.categoryName;

  List pageList = [];
  int pageListStatus = 1;
  Map pageListContinueKeys;

  final scrollController = ScrollController();
  bool headerFloated = false;

  final categoriesBarScrollController = ScrollController();
  final categoriesBarKey = GlobalKey<State>();

  bool isSubCategoryListExpanded = false;

  Future<Map> minSizeCategoryFuture;

  @override
  void initState() {
    super.initState();
    if (isMultiple) {
      minSizeCategoryFuture = getMinSizeCategory();
      minSizeCategoryFuture.then((minSizeCategory) {
        if (minSizeCategory['size'] > 500) toast('您搜索的分类下页面过多，搜索时间可能会较长，建议缩小范围重新搜索');
      });
    } else {
      loadSubCategoryList();
    }

    loadPageList();
    addInfinityListLoadingListener(scrollController, loadPageList);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.routeArgs.parentCategories != null) {
      categoriesBarScrollController.animateTo(
        categoriesBarScrollController.position.maxScrollExtent, 
        duration: Duration(milliseconds: 500), 
        curve: Curves.ease
      );
    }
  }

  @override
  void dispose() { 
    scrollController.dispose();
    categoriesBarScrollController.dispose();
    super.dispose();
  }

  void loadSubCategoryList() async {
    setState(() => subCategoryListStatus = 2);
    try {
      final data = await CategoryApi.getSubCategory(firstCategoryName, subCategoryListContinueKey);
      List list = data['query']['categorymembers'];
      final continueKey = data['continue'] != null ? data['continue']['cmcontinue'] : null;

      int nextStatus = 3;

      if (list.length == 0) {
        nextStatus = 5;
      }

      if (list.length > 0 && continueKey == null) {
        nextStatus = 4;
      }

      setState(() {
        subCategoryListStatus = nextStatus;
        subCategoryList.addAll(list.map((item) => item['title'].replaceFirst('Category:', '')).cast<String>());
        subCategoryListContinueKey = continueKey;
      });
    } catch(e) {
      print('加载子分类失败');
      print(e);
      setState(() => subCategoryListStatus = 0);
    }
  }

  void loadPageList() async {
    if ([2, 4, 5].contains(pageListStatus)) return;
    
    setState(() => pageListStatus = 2);

    try {
      String requestCategoryName = firstCategoryName;
      if (isMultiple) {
        final minSizeCategory = await minSizeCategoryFuture;
        requestCategoryName = minSizeCategory['title'];
      }

      final data = await CategoryApi.searchByCategory(
        requestCategoryName, 
        240, 
        pageListContinueKeys
      );

      if (data['query'] == null) {
        setState(() => pageListStatus = 5);
        return;
      }

      int nextStatus = 3;
      if (this.pageList.length == 0 && data['query']['pages'].values.length == 0) {
        nextStatus = 5;
      }

      if (data['continue'] == null && pageList.length != 0) nextStatus = 4;

      List resultPageList = data['query']['pages'].values.toList();

      // 如果为多分类模式，则过滤出结果中这些分类的交集
      if (isMultiple) {
        resultPageList = widget.routeArgs.categoryList.skip(1).fold(resultPageList, (result, filterCategoryName) {
          return result.where((page) => 
            (page['categories'] ?? []).map((item) => item['title'].replaceFirst('Category:', '')).contains(filterCategoryName)
          ).toList();
        });
      }

      setState(() {
        pageList.addAll(resultPageList);
        pageListStatus = nextStatus;
        pageListContinueKeys = data['continue'];

        if (pageList.length == 0 && nextStatus == 3) loadPageList();
      });
    } catch(e) {
      if (!(e is DioError) && !(e is MoeRequestError)) rethrow;
      print('加载分类下文章失败');
      print(e);
      setState(() => pageListStatus = 0);
    }
  }

  Future<Map> getMinSizeCategory() async {
    final categoryInfoList = await CategoryApi.getCategoryInfo(widget.routeArgs.categoryList);
    final List categoryPageSizeList = categoryInfoList['query']['pages'].values
      .map((item) => {
        'title': item['title'].replaceFirst('Category:', ''),
        'size': item['categoryinfo']['size']
      }).toList();

    final minSizeCategory = categoryPageSizeList.fold(categoryPageSizeList[0], (result, item) => result['size'] < item['size'] ? result : item);
    return minSizeCategory;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<String> categories = widget.routeArgs.parentCategories != null ? 
      [...widget.routeArgs.parentCategories, widget.routeArgs.categoryName] :
      null
    ;
 
    final categoriesBarHeight = categoriesBarKey.currentContext?.findRenderObject()?.paintBounds?.height ?? 0;
    final headerHeight =  statusBarHeight + kToolbarHeight + categoriesBarHeight;

    return Scaffold(
      body: Container(
        child: ListLayoutWithMovableHeader(
          scrollController: scrollController,
          maxDistance: kToolbarHeight,
          header: Container(
            color: theme.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  title: AppBarTitle(widget.routeArgs.categoryName != null ? widget.routeArgs.categoryName : Lang.categoryPage_title),
                  leading: AppBarBackButton(),
                  elevation: 0,
                  actions: [
                    AppBarIcon(
                      icon: Icons.search, 
                      onPressed: () => OneContext().pushNamed('/categorySearch')
                    )
                  ],
                ),

                if (categories != null) (
                  Container(
                    key: categoriesBarKey,
                    padding: EdgeInsets.only(bottom: 7),
                    child: SingleChildScrollView(
                      controller: categoriesBarScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: categories.map((categoryName) =>
                          Row(
                            children: [
                              TouchableOpacity(
                                onPressed: () {
                                  if (categoryName == widget.routeArgs.categoryName) return;
                                  OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                                    pageName: 'Category:$categoryName'
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(categoryName,
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                              ),

                              if (categoryName != widget.routeArgs.categoryName) (
                                Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Icon(Icons.chevron_right,
                                    size: 30,
                                    color: theme.colorScheme.onPrimary
                                  ),
                                )
                              )
                            ],
                          )
                        ).toList(),
                      ),
                    ),
                  )
                )
              ],
            ),
          ),

          listBuilder: (headerFloated) => (
            StructuredListView(
              controller: scrollController,
              itemDataList: pageList,
              padding: EdgeInsets.only(top: headerFloated ? headerHeight : 0),
              headerBuilder: () => (
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.routeArgs.categoryExplainPageName != null) (
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Lang.categoryPage_categoryNameToPage,
                                  style: TextStyle(
                                    color: theme.hintColor,
                                  )
                                ),

                                WidgetSpan(
                                  child: TouchableOpacity(
                                    onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                                      pageName: widget.routeArgs.categoryExplainPageName
                                    )),
                                    child: Text(widget.routeArgs.categoryExplainPageName,
                                      style: TextStyle(
                                        color: theme.accentColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),       
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                        )
                      ),

                      if (subCategoryList.length > 0) (
                        CategoryPageSubCategoryList(
                          visibleLoadMoreButton: subCategoryListStatus == 3,
                          visibleLoadingIndicator: subCategoryListStatus == 2,
                          subCategoryList: subCategoryList,
                          onLoadMoreButtonPressed: loadSubCategoryList,
                        )
                      )
                    ]
                  )
                )
              ),
              
              itemBuilder: (context, itemData, index) => (
                CategoryPageItem(
                  pageName: itemData['title'],
                  imgUrl: itemData['thumbnail'] != null ? itemData['thumbnail']['source'] : null,
                  categories: (itemData['categories'] ?? [])
                    .map((item) => item['title'].replaceAll('Category:', ''))
                    .cast<String>()
                    .toList(),
                  onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                    pageName: itemData['title']
                  )),
                  onCategoryPressed: (categoryName) => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                    pageName: '${Lang.category}:' + categoryName
                  )),
                )
              ),

              footerBuilder: () => InfinityListFooter(
                status: pageListStatus,
                emptyText: Lang.categoryPage_empty,
                onReloadingButtonPrssed: loadPageList
              ),
            )
          ),
        )
      )
    );
  }
}