import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/api/edit.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_icon.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_title.dart';
import 'package:moegirl_plus/database/backup.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/request/moe_request.dart';
import 'package:moegirl_plus/utils/compute_md5.dart';
import 'package:moegirl_plus/utils/debounce.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:moegirl_plus/utils/ui/dialog/loading.dart';
import 'package:moegirl_plus/utils/ui/toast/index.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/compare/index.dart';
import 'package:moegirl_plus/views/edit/tabs/preview.dart';
import 'package:moegirl_plus/views/edit/tabs/wiki_editing.dart';
import 'package:moegirl_plus/views/edit/utils/show_submit_dialog.dart';
import 'package:one_context/one_context.dart';

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

class _EditPageState extends State<EditPage> with SingleTickerProviderStateMixin {
  String wikiCodes = '';
  String originalWikiCodes = '';
  int wikiCodesStatus = 1;
  bool editorQuickInsertBarEnabled = true;
  final editorfocusNode = FocusNode();
  
  String previewContentHtml = '';
  int previewCurrentStatus = 2;
  bool shouldReloadPreview = false;
  bool get newSection => widget.routeArgs.section == 'new';

  TabController tabController;

  // 发现预览视图不响应外部参数的更新了，只有内部setState才会更新，猜测是AutomaticKeepAliveClientMixin导致的，但不知道为什么编辑页面没出问题
  // 这里只好封个controller抛出来用于更新
  EditPagePreviewController previewController;

  String backupIndex = '';

  @override
  void initState() { 
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    
    // 监听tab栏，如果到预览视图且需要重新加载则加载
    tabController.addListener(() {
      if (tabController.index == 1) {
        FocusManager.instance.primaryFocus.unfocus();
        if (!shouldReloadPreview) return;
        loadPreview();
        shouldReloadPreview = false;
      }
    });

    backupIndex = computeMd5(widget.routeArgs.pageName + widget.routeArgs.editRange.toString() + (widget.routeArgs.section ?? ''));    

    (() async {
      await loadWikiCodes();
      checkBackup();
    })();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  Future<void> loadWikiCodes() async {
    if (widget.routeArgs.editRange == EditPageEditRange.newPage || widget.routeArgs.section == 'new') {
      setState(() => wikiCodesStatus = 3);
      return;
    }
    
    setState(() => wikiCodesStatus = 2);
    try {
      final data = await EditApi.getWikiCodes(widget.routeArgs.pageName, widget.routeArgs.section);
      setState(() {
        wikiCodes = originalWikiCodes = data['parse']['wikitext']['*'];
        wikiCodesStatus = 3;
      });
      loadPreview();
    } catch(e) {
      if (!(e is MoeRequestError) && !(e is DioError)) rethrow;
      print('加载维基文本失败');
      print(e);
      setState(() => wikiCodesStatus = 0);
    }
  }

  void loadPreview() async {
    void setPreviewerStatus(int status) {
      // 虽然预览视图的status在内部，但初始值还是需要的，因为tab栏懒加载的缘故，这里还是要为预览视图保存一份状态用于初始化
      previewCurrentStatus = status;
      // tab栏貌似是懒加载的，只有在选择后才会走initState，controller才能抛出来，这里要额外做判断防null
      previewController?.setStatus(status);
    }
    
    setPreviewerStatus(2);
    try {
      final data = await EditApi.getPreview(wikiCodes, widget.routeArgs.pageName);
      setState(() {
        previewContentHtml = data['parse']['text']['*'];
        setPreviewerStatus(3);
      });
    } catch(e) {
      if (!(e is DioErrorType)) rethrow;
      print('获取编辑预览失败');
      print(e);
      setPreviewerStatus(0);
    }
  }

  // 真正的备份执行函数
  void __makeBackup(text) {
    BackupDbClient.set(BackupType.edit, backupIndex, text,
      extra: {
        'timestamp': DateTime.now().millisecondsSinceEpoch
      }
    );
  }

  // 备份函数防抖
  void makeBackup(String text) {
    debounce(__makeBackup, Duration(seconds: 2))(text);
  }
  
  void checkBackup() async {
    final backup = await BackupDbClient.get(BackupType.edit, backupIndex);
    if (backup == null) return;
    
    final backupDate = DateTime.fromMillisecondsSinceEpoch(backup.extra['timestamp']);
    final lastEditDate = DateTime.tryParse(await EditApi.getLastTimestamp(widget.routeArgs.pageName)) ?? DateTime.fromMillisecondsSinceEpoch(0).add(Duration(hours: 8));
    final isNewEdit = widget.routeArgs.editRange == EditPageEditRange.newPage || newSection;
    final isExpired = !isNewEdit && backupDate.isBefore(lastEditDate);

    final format = [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss];
    final backupDateStr = formatDate(backupDate, format);

    void onCheck(Completer completer) async {
      if (!isExpired) {
        setState(() => wikiCodes = backup.content);
        toast(Lang.backupRestored);
        loadPreview();
        OneContext().pop();
        BackupDbClient.delete(BackupType.edit, backupIndex);
        return;
      }

      final lastEditDateStr = formatDate(lastEditDate, format);
      final attentionResult = await showAlert<dynamic>(
        title: Lang.attention,
        content: Lang.expiredBackupHint,
        barrierDismissible: false,
        checkButtonText: Lang.confirmRecovery,
        closeButtonText: Lang.back,
        visibleCloseButton: true,
        moreActionsBuilder: (completer) => [
          TextButton(
            onPressed: () => completer.complete(),
            child: Text(Lang.restoreToClipboard),
          )
        ]
      );

      if (attentionResult == null) {
        Clipboard.setData(ClipboardData(text: backup.content));
        toast(Lang.restoredToClipboard);
        OneContext().pop();
        OneContext().pop();
        return;
      }

      if (attentionResult) {
        setState(() => wikiCodes = backup.content);
        toast(Lang.backupRestored);
        loadPreview();
        BackupDbClient.delete(BackupType.edit, backupIndex);
        OneContext().pop();
        return;
      }
    }

    onClose(Completer completer) {
      BackupDbClient.delete(BackupType.edit, backupIndex);
      OneContext().pop();
    }

    final result = await showAlert<dynamic>(
      title: Lang.foundBackup,
      content: Lang.hasBackupHint(backupDateStr),
      visibleCloseButton: true,
      checkButtonText: Lang.recovery,
      closeButtonText: Lang.discard,
      autoClose: false,
      barrierDismissible: false,
      onPop: (completer) async => true,
      onCheck: onCheck,
      onClose: onClose,
      moreActionsBuilder: (completer) => [
        if (!isNewEdit) (
          TextButton(
            onPressed: () {
              OneContext().pushNamed('/compare', arguments: ComparePageRouteArgs(
                fromText: wikiCodes,
                toText: backup.content,
                fromTitle: Lang.lastEditCodes,
                toTitle: Lang.backupCodes
              ));
            },
            child: Text(Lang.viewDiff),
          )
        )
      ]
    );
  }

  String summaryBackup = '';  // 备份，再次打开摘要输入还会还原这个值
  void submit() async {
    final isNewSection = widget.routeArgs.section == 'new';
    
    // 不在新push路由(开启dialog)前unfocus会导致关闭页面时自动focus，且光标滚动到最下
    editorfocusNode.unfocus();
    
    final getTitleRegex = RegExp(r'^=+(.+?)=+\s*');
    String summary;
    String wikiCodes = this.wikiCodes;
    if (!isNewSection) {
      // 离开页面时要禁用快速插入栏，否则在在其他页面开启键盘时快速插入栏也会跟着显示
      setState(() => editorQuickInsertBarEnabled = false);
      
      final inputResult = await showEditPageSubmitDialog(summaryBackup);
      summaryBackup = inputResult.summary;
      
      await Future.delayed(Duration(milliseconds: 300));  // 300毫秒后再启用快速插入栏，否则在关闭dialog的瞬间就会显示出来，不好看
      setState(() => editorQuickInsertBarEnabled = true);

      if (!inputResult.submit) return;

      // 添加章节信息，修改时允许没有标题
      final sectionMatch = getTitleRegex.firstMatch(wikiCodes);
      String sectionName = sectionMatch != null ? sectionMatch[1].trim() : Lang.noSpecifiedSection;
      summary = '/*$sectionName*/${inputResult.summary}';
    } else {
      // 添加话题时，不允许没有标题
      if (!wikiCodes.contains(getTitleRegex)) return toast(Lang.emptySectionHint);
      summary = getTitleRegex.firstMatch(wikiCodes)[1].trim();
      // 在添加话题时，summary被视为标题，这时如果不把wiki代码中的标题替换掉将导致出现两个标题
      wikiCodes = wikiCodes.replaceFirst(getTitleRegex, '').trim();

      if (wikiCodes == '') return toast(Lang.emptyContentHint);
    }

    // 提交编辑主体逻辑
    showLoading(text: Lang.submitting + '...');
    try {
      await EditApi.editArticle(
        pageName: widget.routeArgs.pageName, 
        section: widget.routeArgs.section, 
        content: wikiCodes, 
        summary: summary
      );

      BackupDbClient.delete(BackupType.edit, backupIndex);

      toast(Lang.edited, position: ToastPosition.center);
      ArticlePage.popNextReloadMark = true;
      OneContext().pop();
    } catch(e) {
      if (!(e is String) && !(e is MoeRequestError) && !(e is DioError)) rethrow;
      print('提交编辑失败');
      print(e);
      if (e is String) {
        final message = {
          'editconflict': Lang.editconflictHint,
          'protectedpage': Lang.protectedPageHint,
          'readonly': Lang.databaseReadonlyHint
        }[e] ?? Lang.unkownErr;

        toast(message);
      } else {
        toast(Lang.netErrToRetry);
        // 这里有个小坑，如果不放到微任务里，下面为了关闭loading的OneContext.pop()就会把再次显示的提交编辑的dialog关闭
        if (!isNewSection) Future.microtask(submit);
      }
    } finally {
      OneContext().pop();
    }
  }

  Future<bool> willPop() async {
    if (wikiCodes == originalWikiCodes) return true;
    editorfocusNode.unfocus();
    final result = await showAlert<bool>(
      content: Lang.editleaveHint,
      visibleCloseButton: true
    );
    if (!result) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final actionName = {
      EditPageEditRange.full: Lang.edit,
      EditPageEditRange.section: Lang.editSection,
      EditPageEditRange.newPage: Lang.create
    }[widget.routeArgs.editRange];
    
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: AppBarTitle('$actionName：${widget.routeArgs.pageName}'),
        leading: AppBarBackButton(willPop: willPop),
        actions: [
          AppBarIcon(
            icon: Icons.done, 
            onPressed: submit
          )
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: Lang.wikiText),
            Tab(text: Lang.previewView)
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: willPop,
        child: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            EditPageWikiEditing(
              focusNode: editorfocusNode,
              quickInsertBarEnabled: editorQuickInsertBarEnabled,
              value: wikiCodes,
              status: wikiCodesStatus,
              newSection: newSection,
              onContentChanged: (text) {
                wikiCodes = text;
                shouldReloadPreview = true;
                makeBackup(text);
              },
              onReloadButtonPressed: loadWikiCodes,
            ),
            EditPagePreview(
              html: previewContentHtml,
              initialStatus: previewCurrentStatus,
              emitController: (controller) => previewController = controller,
              onReloadButtonReload: loadPreview,
            )
          ],
        )
      ),
    );
  }
}