import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/indexedView.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/components/structured_list_view.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_viewer/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_viewer/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:moegirl_viewer/providers/comment.dart';
import 'package:moegirl_viewer/views/comment/components/item.dart';
import 'package:provider/provider.dart';

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
  final scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - scrollController.position.pixels < 200) {
        commentProvider.loadNext(widget.routeArgs.pageId);
      }
    });
  }

  @override
  void dispose() { 
    super.dispose();
    scrollController.dispose();
  }

  void showCommentEditor() {
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle('评论：${widget.routeArgs.pageName}'),
        leading: AppBarBackButton(),
        elevation: 0,
        actions: [AppBarIcon(icon: Icons.add_comment, onPressed: this.showCommentEditor)],
      ),
      body: NightSelector(
        builder: (isNight) => (
          Container(
            color: isNight ? theme.backgroundColor : Color(0xffeeeeee),
            child: Selector<CommentProviderModel, ProviderCommentData>(
              selector: (_, model) => model.data[widget.routeArgs.pageId].clone(),
              shouldRebuild: (prev, next) {
                if (prev.count != next.count) return true;
                if (prev.status != next.status) return true;
                if (prev != next) return true;
                return false;
              },
              builder: (_, commentData, __) => (
                StructuredListView(
                  controller: scrollController,
                  itemDataList: commentData.commentTree,

                  headerBuilder: () {
                    if (commentData.popular.length == 0) return Container(width: 0, height: 0);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('热门评论',
                            style: TextStyle(
                              color: theme.hintColor,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        
                        ...commentData.popular.map((itemData) =>
                          CommentPageItem(
                            isPopular: true,
                            commentData: itemData,
                            pageId: widget.routeArgs.pageId,
                            visibleDelButton: accountProvider.userName == itemData['username'],
                            visibleRpleyButton: false,
                          )
                        ).toList(),

                        Padding(
                          padding: EdgeInsets.all(10).copyWith(top: 9),
                          child: Text('共${commentData.count}条评论',
                            style: TextStyle(
                              color: theme.hintColor,
                              fontSize: 17
                            ),
                          ),
                        )
                      ]
                    );
                  },
                  
                  itemBuilder: (context, itemData) => (
                    CommentPageItem(
                      commentData: itemData,
                      pageId: widget.routeArgs.pageId,
                      visibleDelButton: accountProvider.userName == itemData['username'],
                      visibleReply: true,
                      visibleRpleyButton: true,
                    )
                  ),

                  footerBuilder: () => IndexedView(
                    index: commentData.status, 
                    builders: {
                      0: () => CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => commentProvider.loadNext(widget.routeArgs.pageId),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Text('加载失败，点击重试',
                            style: TextStyle(color: theme.hintColor),
                          ),
                        ),
                      ),

                      2: () => Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: StyledCircularProgressIndicator(),
                      ),

                      4: () => Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 20).copyWith(top: 19),
                        child: Text('已经没有啦',
                          style: TextStyle(
                            color: theme.disabledColor,
                            fontSize: 17
                          )
                        ),
                      ),

                      5: () => Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 20).copyWith(top: 19),
                        child: Text('暂无评论',
                          style: TextStyle(
                            color: theme.disabledColor,
                            fontSize: 17
                          )
                        ),
                      )
                    }
                  )
                )
              ),
            ),
          )
        ),
      )
    );
  }
}