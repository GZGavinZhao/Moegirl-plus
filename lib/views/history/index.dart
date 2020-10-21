import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/app_bar_icon.dart';
import 'package:moegirl_viewer/utils/reading_history_manager.dart';

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
  
  @override
  void initState() { 
    super.initState();
    loadList();
  }

  void loadList() async {
    final allList = await ReadingHistoryManager.getList();
    setState(() {
      allList.forEach((item) {
        
      });
    });
  }

  void clearHistory() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('浏览历史'),
        actions: [
          appBarIcon(Icons.delete, clearHistory)
        ],
      ),
      body: Container()
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
    final time = formatDate(date, [hh, ':', mm]);
    return '$prefix $time';
  } else {
    return formatDate(date, [
      if (date.year != DateTime.now().year) yyyy,
      mm, '/', dd, ' ', hh, ':', mm
    ]);
  }
}