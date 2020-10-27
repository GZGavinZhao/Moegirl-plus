import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/components/structured_list_view.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/comment.dart';
import 'package:moegirl_viewer/views/comment/components/item.dart';

class CommentPageRouteArgs {
  final String pageName;
  final int pageId;

  CommentPageRouteArgs({
    @required this.pageName,  
    @required this.pageId
  });
}

class CommentPage extends StatefulWidget {
  final CommentPageRouteArgs routeArgs;
  CommentPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commentData = commentProvider.data[widget.routeArgs.pageId];
    
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle('评论：${widget.routeArgs.pageName}'),
        leading: AppBarBackButton(),
        elevation: 0,
      ),
      body: NightSelector(
        builder: (isNight) => (
          Container(
            color: isNight ? theme.backgroundColor : Color(0xffeeeeee),
            child: StructuredListView(
              itemDataList: commentData.commentTree,
              itemBuilder: (context, itemData) => (
                CommentPageItem(
                  commentData: itemData,
                  pageId: widget.routeArgs.pageId,
                  visibleDelButton: accountProvider.userName == itemData['username'],
                  visibleReply: true,
                )
              )
            ),
          )
        ),
      )
    );
  }
}