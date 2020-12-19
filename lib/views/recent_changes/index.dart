import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/edit_record.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/components/structured_list_view.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_viewer/components/styled_widgets/refresh_indicator.dart';
import 'package:moegirl_viewer/components/styled_widgets/scrollbar.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/views/recent_changes/components/item.dart';
import 'package:moegirl_viewer/views/recent_changes/utils/show_options_dialog.dart';

class RecentChangesPageRouteArgs {
  
  RecentChangesPageRouteArgs();
}

class RecentChangesPage extends StatefulWidget {
  final RecentChangesPageRouteArgs routeArgs;
  RecentChangesPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _RecentChangesPageState createState() => _RecentChangesPageState();
}

class _RecentChangesPageState extends State<RecentChangesPage> with AfterLayoutMixin {
  List changesList = [];
  num status = 1;
  RecentChangesOptions get recentChangesOptions => otherPref.recentChangesOptions ?? RecentChangesOptions();
  set recentChangesOptions(RecentChangesOptions value) => otherPref.recentChangesOptions = value;
  final scrollController = ScrollController();

  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final optionsBarKey = GlobalKey<State>();
  
  @override
  void afterFirstLayout(BuildContext context) {
    refreshIndicatorKey.currentState.show();
  }

  @override
  void dispose() { 
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadChanges() async {
    if (status == 2) return;
    setState(() => status = 2);

    try {
      final options = recentChangesOptions;
      final List data = await EditRecordApi.getRecentChanges(
        startISO: DateTime.now().subtract(Duration(days: options.daysAgo)).toIso8601String(),
        limit: options.totalLimit,
        excludeUser: !options.includeSelf && accountProvider.isLoggedIn ? accountProvider.userName : null,
        includeMinor: options.includeMinor,
        includeRobot: options.includeRobot
      );

      final dataWithDetails = data.fold<List>([], (result, item) {
        if (result.every((resultItem) => resultItem['title'] != item['title'])) {
          result.add({ 
            ...item, 
            'details': [item],  // 本身也算作详细信息的一部分
            'users': []
          });
        } else {
          result.singleWhere((resultItem) => resultItem['title'] == item['title'])['details'].add(item);
        }

        return result;
      });

      // 添加users和各自的编辑次数
      dataWithDetails.forEach((item) {
        item['details'].forEach((detailItem) {
          final foundUserIndex = item['users'].indexWhere((user) => user['name'] == detailItem['user']);
          if (foundUserIndex != -1) {
            item['users'][foundUserIndex]['total']++;
          } else {
            item['users'].add({ 'name': detailItem['user'], 'total': 1 });
          }
        });
      });

      setState(() {
        changesList = dataWithDetails;
        status = 3;
      });
    } catch(e) {
      if (!(e is DioError) && !(e is MoeRequestError)) rethrow;
      print('加载最近更改列表失败');
      print(e);
      setState(() => status = 0);
    }
  }

  void showOptionsDialog() async {
    final newOptions = await showRecentChangesOptionsDialog(context, recentChangesOptions);
    recentChangesOptions = newOptions;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AppBarTitle('最近更改'),
        leading: AppBarBackButton(),
        actions: [AppBarIcon(
          icon: Icons.tune,
          onPressed: showOptionsDialog,
        )],
      ),
      body: NightSelector(
        builder: (isNight) => (
          Container(
            color: isNight ? theme.backgroundColor : Color(0xffeeeeee),
            child: StyledScrollbar(
              child: StyledRefreshIndicator(
                bodyKey: refreshIndicatorKey,
                onRefresh: loadChanges,
                child: StructuredListView(
                  itemDataList: changesList,          
                  itemBuilder: (context, itemData, index) => (
                    RecentChangesItem(
                      type: itemData['type'],
                      pageName: itemData['title'],
                      comment: itemData['comment'],
                      users: itemData['users'],
                      newLength: itemData['newlen'],
                      oldLength: itemData['oldlen'],
                      revId: itemData['revid'],
                      oldRevId: itemData['old_revid'],
                      dateISO: itemData['timestamp'],
                      editDetails: itemData['details'],
                    )
                  ),
                ),
              ),
              ),
          )
        ),
      )
    );
  }
}