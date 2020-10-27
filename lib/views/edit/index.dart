import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/api/edit.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_viewer/request/moe_request.dart';
import 'package:moegirl_viewer/views/edit/tabs/preview.dart';
import 'package:moegirl_viewer/views/edit/tabs/wiki_editing.dart';

class EditPageRouteArgs {
  final String pageName;
  final String section;
  final EditPageEditRange editRange;

  EditPageRouteArgs({
    @required this.pageName,
    @required this.editRange,
    this.section,
  });
}

enum EditPageEditRange {
  full, section, newPage
}

class EditPage extends StatefulWidget {
  final EditPageRouteArgs routeArgs;
  EditPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String wikiEditingCodes = '';
  int wikiCodesStatus = 0;
  String previewContentHtml = '';
  int previewStatus = 0;

  @override
  void initState() { 
    super.initState();
    loadWikiCodes();
  }

  void loadWikiCodes() async {
    setState(() => wikiCodesStatus = 2);
    try {
      final data = await EditApi.getWikiCodes(widget.routeArgs.pageName, widget.routeArgs.section);
      setState(() {
        wikiEditingCodes = data['parse']['wikitext']['*'];
        wikiCodesStatus = 3;
      });
    } catch(e) {
      if (!(e is MoeRequestError) || !(e is DioError)) rethrow;
      print('加载维基文本失败');
      print(e);
      setState(() => wikiCodesStatus = 0);
    }
  }
  
  void submit() {

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionName = {
      EditPageEditRange.full: '编辑',
      EditPageEditRange.section: '编辑段落',
      EditPageEditRange.newPage: '新建'
    }[widget.routeArgs.editRange];
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle('$actionName：${widget.routeArgs.pageName}'),
          leading: AppBarBackButton(),
          actions: [
            AppBarIcon(
              icon: Icons.done, 
              onPressed: submit
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: '维基文本'),
              Tab(text: '预览视图')
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EditPageWikiEditing(
              value: wikiEditingCodes,
              status: wikiCodesStatus,
              onChanged: (text) => wikiEditingCodes = text,
              onReloadButtonPressed: loadWikiCodes,
            ),
            EditPagePreview(),
          ],
        )
      )
    );
  }
}