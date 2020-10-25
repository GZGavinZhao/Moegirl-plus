import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';

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
        body: Container()
      )
    );
  }
}