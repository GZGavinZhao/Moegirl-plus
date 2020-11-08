import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/article_view/index.dart';
import 'package:moegirl_viewer/components/indexedView.dart';
import 'package:moegirl_viewer/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_viewer/views/article/components/contents/index.dart';

class EditPagePreview extends StatefulWidget {
  final String html;
  final int initialStatus;
  final void Function(EditPagePreviewController) emitController;
  final void Function() onReloadButtonReload;
  
  EditPagePreview({
    @required this.html,
    @required this.initialStatus,
    @required this.emitController,
    @required this.onReloadButtonReload,
    Key key
  }) : super(key: key);

  @override
  _EditPagePreviewState createState() => _EditPagePreviewState();
}

class _EditPagePreviewState extends State<EditPagePreview> with AutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;
  int status = 2;
  dynamic contentsData;

  ArticleViewController articleViewController;

  @override
  void initState() { 
    super.initState();
    widget.emitController(EditPagePreviewController(setStatus));

    status = widget.initialStatus;
  }

  void setStatus(int status) {
    setState(() => this.status = status);
  }

  void jumpToAnchor(String anchor) {
    articleViewController.injectScript('moegirl.method.link.gotoAnchor("$anchor", -10)');
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      endDrawer: ArticlePageContents(
        notInTopLayer: true,
        contentsData: contentsData,
        onSectionPressed: jumpToAnchor,
      ),
      body: Container(
        color: theme.backgroundColor,
        alignment: Alignment.center,
        child: IndexedView<int>(
          index: status,
          builders: {
            0: () => TextButton(
              child: Text('重新加载',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              onPressed: widget.onReloadButtonReload,
            ),
            2: () => StyledCircularProgressIndicator(),
            3: () => ArticleView(
              html: widget.html,
              disabledLink: true,
              emitContentData: (data) => setState(() => contentsData = data),
              emitArticleController: (controller) => articleViewController = controller,
            )
          },
        ),
      )
    );
  }
}

class EditPagePreviewController {
  final void Function(int status) setStatus;

  EditPagePreviewController(this.setStatus);
}