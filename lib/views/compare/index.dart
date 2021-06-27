import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/api/edit.dart';
import 'package:moegirl_plus/api/edit_record.dart';
import 'package:moegirl_plus/components/indexed_view.dart';
import 'package:moegirl_plus/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/compare/components/diff_content.dart';
import 'package:moegirl_plus/views/compare/utils/collect_diff_blocks_from_html.dart';
import 'package:moegirl_plus/views/compare/utils/show_undo_dialog.dart';
import 'package:one_context/one_context.dart';

class ComparePageRouteArgs {
  final int formRevId;
  final int toRevId;
  final String pageName;
  
  ComparePageRouteArgs({
    @required this.formRevId,   // 只传这个会和最新版本比较
    this.toRevId,
    @required this.pageName
  });
}

class ComparePage extends StatefulWidget {
  final ComparePageRouteArgs routeArgs;
  ComparePage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> with SingleTickerProviderStateMixin {
  dynamic comparedData;
  List<DiffLine> leftLines = [];
  List<DiffLine> rightLines = [];
  int status = 1;

  TabController tabController;
  List<List<double>> syncRowHeights;

  @override
  void initState() { 
    super.initState();
    loadComparedData();

    tabController = TabController(length: 2, vsync: this);
  }

  void loadComparedData() async {
    setState(() => status = 2);
    try {
      final data = await EditRecordApi.compurePage(
        fromTitle: widget.routeArgs.pageName,
        fromRev: widget.routeArgs.formRevId, 
        toTitle: widget.routeArgs.pageName, 
        toRev: widget.routeArgs.toRevId
      );

      // 返回的是一个由tr组成的列表，没有table会导致html解析失败
      final diffBlocks = collectDiffBlocksFromHtml('<table>${data['compare']['*']}</table>');

      setState(() {
        comparedData = data['compare'];
        leftLines = diffBlocks.map((item) => item.left).cast<DiffLine>().toList();
        rightLines = diffBlocks.map((item) => item.right).cast<DiffLine>().toList();
        status = 3;
      });
    } catch(e) {
      if (!(e is MoeRequestError) && !(e is DioError)) rethrow;
      print('加载页面差异数据失败');
      print(e);
      setState(() => status = 0);
    }
  }

  void showUndoDialog() async {
    final result = await showComparePageUndoDialog();
    if (!result.submit) return;
    final String userName = comparedData['touser'];
    final summaryPrefix = Lang.comparesummaryPrefix(userName, widget.routeArgs.toRevId.toString());

    showLoading();
    try {
      await EditApi.editArticle(
        pageName: widget.routeArgs.pageName, 
        summary: summaryPrefix + Lang.undoReason + '：' + result.summary,
        undoRevId: widget.routeArgs.toRevId
      );

      toast(Lang.undid, position: ToastPosition.center);
    } catch(e) {
      print('执行撤销失败');
      print(e);
      toast(Lang.undoFail);
      Future.microtask(() => showComparePageUndoDialog(result.summary));
    } finally {
      OneContext().pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoggedInSelector(
      builder: (isLoggedIn) => (
        Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: AppBarTitle('${Lang.diff}：${widget.routeArgs.pageName}'),
            leading: AppBarBackButton(),
            actions: [
              if (isLoggedIn) (
                AppBarIcon(
                  icon: Icons.low_priority, 
                  onPressed: showUndoDialog
                )
              )
            ],
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(text: Lang.before),
                Tab(text: Lang.after)
              ],
            )
          ),

          body: Container(
            alignment: Alignment.center,
            child: IndexedView(
              index: status,
              builders: {
                0: () => TextButton(
                  onPressed: loadComparedData,
                  child: Text(Lang.reload,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
                2: () => StyledCircularProgressIndicator(),
                3: () => TabBarView(
                  controller: tabController,
                  children: [
                    CompareDiffContent(
                      userName: comparedData['fromuser'],
                      comment: comparedData['fromcomment'],
                      diffLines: leftLines,
                    ),

                    CompareDiffContent(
                      userName: comparedData['touser'],
                      comment: comparedData['tocomment'],
                      diffLines: rightLines,
                    )
                  ],
                )
              },
            ),
          )
        )
      )
    );
  }
}


