import 'package:after_layout/after_layout.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/api/edit_record.dart';
import 'package:moegirl_plus/components/infinity_list_footer.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/structured_list_view.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/components/styled_widgets/refresh_indicator.dart';
import 'package:moegirl_plus/components/styled_widgets/scrollbar.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/utils/add_infinity_list_loading_listener.dart';
import 'package:moegirl_plus/views/contribution/components/item.dart';

class ContributionPageRouteArgs {
  final String userName;

  ContributionPageRouteArgs({this.userName});
}

class ContributionPage extends StatefulWidget {
  final ContributionPageRouteArgs routeArgs;
  ContributionPage(this.routeArgs, {Key key}) : super(key: key);

  @override
  _ContributionPageState createState() => _ContributionPageState();
}

class _ContributionPageState extends State<ContributionPage> with AfterLayoutMixin {
  final List contributionList = [];
  num status = 1;
  String continueKey;

  DateTime startDate = DateTime.now().subtract(Duration(days: 6));
  DateTime endDate = DateTime.now();

  final scrollController = ScrollController();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() { 
    super.initState();

    // 监听滚动，进行上拉加载
    addInfinityListLoadingListener(scrollController, load);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    refreshIndicatorKey.currentState.show();
  }

  @override
  void dispose() { 
    scrollController.dispose();
    super.dispose();
  }

  Future load([bool refresh = false]) async {
    if ([2, 2.1, 4, 5].contains(status) && !refresh) return;

    setState(() {
      status = refresh ? 2.1 : 2;
      if (refresh) contributionList.clear();
    });

    try {
      final data = await EditRecordApi.getUserContribution(
        userName: widget.routeArgs.userName,
        // 起始时间是从当前时间开始的，所以start要传end，end传start
        startISO: endDate.toIso8601String(),
        endISO: startDate.toIso8601String(),
        continueKey: this.continueKey
      );

      final String continueKey = data['continue'] != null ? data['continue']['uccontinue'] : null;
      final List list = data['query']['usercontribs'];

      int status = 3;

      if (continueKey == null && list.length != 0) {
        status = 4;
      }

      if (list.length == 0) {
        status = 5;
      }

      setState(() {
        contributionList.addAll(list);
        this.status = status;
        this.continueKey = continueKey;
      });
    } catch(e) {
      print('加载用户贡献列表失败');
      print(e);
    }
  }

  /// startDate，endDate
  void showDateSelectionDialog(String settingDate) async {
    final theme = Theme.of(context);
    DateTime startDate = this.startDate;
    DateTime endDate = this.endDate;
    DateTime resultDate;

    await showCupertinoModalPopup(
      context: context,
      useRootNavigator: false,
      builder: (context) => (
        CupertinoTheme(
          data: CupertinoThemeData(
            brightness: theme.brightness,
          ),
          child: Container(
            height: 200,
            color: theme.colorScheme.surface,
            child: CupertinoDatePicker(
              initialDateTime: settingDate == 'startDate' ? startDate : endDate,
              maximumYear: DateTime.now().year,
              minimumYear: 2010,
              minimumDate: DateTime.parse('2010-01-01'),
              maximumDate: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (date) => resultDate = date,
            ),
          ),
        )
      )
    );

    if (resultDate == null) return;
    if (settingDate == 'startDate') {
      startDate = resultDate;
    } else {
      endDate = resultDate;
    }

    // 如果起始时间大于结束时间，则两个时间互换
    if (startDate.millisecondsSinceEpoch > endDate.millisecondsSinceEpoch) {
      final endDatecache = endDate;
      endDate = startDate;
      startDate = endDatecache;
    }

    setState(() {
      this.startDate = startDate;
      this.endDate = endDate;
    });

    refreshIndicatorKey.currentState.show();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final optionBarWidget = Container(
      color: theme.primaryColor,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Material(
              color: theme.primaryColor,
              child: InkWell(
                onTap: () => showDateSelectionDialog('startDate'),
                child: Center(
                  child: Text(formatDate(startDate, [yyyy, '-', mm, '-', dd]),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('—',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 16
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: theme.primaryColor,
              child:  InkWell(
                onTap: () => showDateSelectionDialog('endDate'),
                child: Center(
                  child: Text(formatDate(endDate, [yyyy, '-', mm, '-', dd]),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16
                    )
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );

    final listWidget = StyledRefreshIndicator(
      bodyKey: refreshIndicatorKey,
      onRefresh: () => load(true),
      child: StyledScrollbar(
        child: StructuredListView(
          controller: scrollController,
          itemDataList: contributionList,
          itemBuilder: (context, itemData, index) {
            return ContributionItem(
              pageName: itemData['title'],
              revId: itemData['revid'],
              prevRevId: itemData['parentid'],
              comment: itemData['comment'],
              timestamp: itemData['timestamp'],
              diffSize: itemData['sizediff'],
            );
          },

          footerBuilder: () => InfinityListFooter(
            status: status,
            onReloadingButtonPrssed: load,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle('${l.contributionPage_title}：${widget.routeArgs.userName}'),
        elevation: 0,
        leading: AppBarBackButton(),
      ),
      body: NightSelector(
        builder: (isNight) => (
          Container(
            color: isNight ? theme.backgroundColor : Color(0xffeeeeee),
            child: Column(
              children: [
                optionBarWidget,
                Expanded(
                  child: listWidget,
                )
              ],
            ),
          )
        ),
      )
    );
  }
}
