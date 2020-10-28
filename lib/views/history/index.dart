import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/structured_list_view.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_viewer/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_viewer/utils/reading_history_manager.dart';
import 'package:moegirl_viewer/utils/ui/dialog/alert.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/history/components/item.dart';
import 'package:moegirl_viewer/views/history/components/title.dart';
import 'package:one_context/one_context.dart';

class HistoryPageRouteArgs {
  
  HistoryPageRouteArgs();
}

class HistoryPage extends StatefulWidget {
  final HistoryPageRouteArgs routeArgs;
  HistoryPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int listCount = 0;
  List<ReadingHistoryWithDisplayDate> todayList = [];
  List<ReadingHistoryWithDisplayDate> yesterdayList = [];
  List<ReadingHistoryWithDisplayDate> agoList = [];
  int status = 1; // 1：初始化，2：加载中，3：加载完成，5：加载过，但没有数据
  
  @override
  void initState() { 
    super.initState();
    refreshList();
  }

  Future<void> refreshList() async {
    setState(() {
      status = 2;
      todayList = [];
      yesterdayList = [];
      agoList = [];
    });

    final allList = await ReadingHistoryManager.getList();
    setState(() => status = allList.length != 0 ? 3 : 5);
    final yesterdayDate = DateTime.now().subtract(Duration(days: 1));

    final yesterdayBeginDate = yesterdayDate.subtract(Duration(
      hours: yesterdayDate.hour,
      minutes: yesterdayDate.minute,
      seconds: yesterdayDate.second,
      milliseconds: yesterdayDate.millisecond,
      microseconds: yesterdayDate.microsecond
    ));
    final yesterdayBeginTimestamp = yesterdayBeginDate.millisecondsSinceEpoch;
    final yesterdayEndTimestamp = yesterdayBeginDate.add(Duration(
      hours: 23,
      minutes: 59,
      seconds: 59,
      milliseconds: 999,
      microseconds: 999
    )).millisecondsSinceEpoch;

    setState(() {
      allList.forEach((item) {
        if (item.timestamp > yesterdayEndTimestamp) {
          todayList.add(ReadingHistoryWithDisplayDate.fromReadingHistory(item, '今天'));
        } else if (item.timestamp < yesterdayBeginTimestamp) {
          agoList.add(ReadingHistoryWithDisplayDate.fromReadingHistory(item));
        } else {
          yesterdayList.add(ReadingHistoryWithDisplayDate.fromReadingHistory(item, '昨天'));
        }
      });
    });
  }

  void clearHistory() async {
    final result = await showAlert(
      content: '确定要清空历史记录吗？',
      visibleCloseButton: true
    );
    if (!result) return;
    ReadingHistoryManager.clear();
    setState(() {
      status = 5;
      todayList = [];
      yesterdayList = [];
      agoList = [];
    });
  }

  @override
  Widget build(BuildContext context) {    
    final theme = Theme.of(context);
    final fullListForListViewBuilder = [
      if (todayList.length != 0) { 'type': 'title', 'title': '今天' },
      ...todayList.map<Map>((item) => { 'type': 'item', 'data': item }),
      if (yesterdayList.length != 0) { 'type': 'title', 'title': '昨天' },
      ...yesterdayList.map<Map>((item) => { 'type': 'item', 'data': item }),
      if (agoList.length != 0) { 'type': 'title', 'title': '更早' },
      ...agoList.map<Map>((item) => { 'type': 'item', 'data': item })
    ];
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AppBarTitle('浏览历史'),
        leading: AppBarBackButton(),
        actions: [
          if (status == 3) AppBarIcon(
            icon: Icons.delete, 
            onPressed: clearHistory
          )
        ],
      ),
      body: Container(
        child: IndexedStack(
          alignment: Alignment.center,
          index: { 0:2, 1:2, 2:2, 3:0, 5:1 }[status],
          children: [
            StructuredListView(
              itemDataList: fullListForListViewBuilder,
              itemBuilder: (context, itemData) {
                if (itemData['type'] == 'title') {
                  return HistoryPageTitle(text: itemData['title']);
                } else {
                  return HistoryPageItem(
                    data: itemData['data'],
                    onPressed: (pageName) => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                      pageName: pageName,
                      displayPageName: itemData['data'].displayPageName
                    )),
                  );
                }
              }
            ),
            Text('暂无记录',
              style: TextStyle(
                color: theme.disabledColor,
                fontSize: 18
              ),
            ),
            StyledCircularProgressIndicator()
          ],
        ),
      )
    );
  }
}

class ReadingHistoryWithDisplayDate extends ReadingHistory {
  String displayDate;

  ReadingHistoryWithDisplayDate({
    String pageName,
    String displayPageName,
    int timestamp,
    String imgPath,
    this.displayDate
  }): super(
    pageName: pageName,
    displayPageName: displayPageName,
    timestamp: timestamp,
    imgPath: imgPath
  );

  ReadingHistoryWithDisplayDate.fromReadingHistory(ReadingHistory readingHistory, [String displayNamePrefix]) {
    pageName = readingHistory.pageName;
    displayPageName = readingHistory.displayPageName;
    timestamp = readingHistory.timestamp;
    imgPath = readingHistory.imgPath;
    displayDate = _displayDate(timestamp, displayNamePrefix);
  }
}

String _displayDate(int timestamp, [String prefix]) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  if (prefix != null) {
    final time = formatDate(date, [HH, ':', nn]);
    return '$prefix $time';
  } else {
    return formatDate(date, [
      if (date.year != DateTime.now().year) yyyy,
      mm, '/', dd, ' ', HH, ':', nn
    ]);
  }
}