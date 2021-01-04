// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_Hant locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_Hant';

  static m0(status) => "${Intl.select(status, {'permissionsChecking': '检查权限中', 'addTheme': '添加话题', 'full': '编辑此页', 'disabled': '无权编辑此页', })}";

  static m1(isExistsInWatchList) => "{isExistsInWatchList, select, true {移出监视列表} false{加入监视列表} }";

  static m2(isWatched) => "{isWatched, select, true {已移出监视列表} false {已加入监视列表} }";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "articlePage_articleMissedHint" : MessageLookupByLibrary.simpleMessage("该页面还未创建"),
    "articlePage_commentButtonLoadingHint" : MessageLookupByLibrary.simpleMessage("加载中"),
    "articlePage_contents_title" : MessageLookupByLibrary.simpleMessage("目录"),
    "articlePage_header_moreButtonTooltip" : MessageLookupByLibrary.simpleMessage("更多选项"),
    "articlePage_header_moreMenuEditButton" : m0,
    "articlePage_header_moreMenuGotoShareButton" : MessageLookupByLibrary.simpleMessage("分享"),
    "articlePage_header_moreMenuGotoTalkPageButton" : MessageLookupByLibrary.simpleMessage("前往讨论页"),
    "articlePage_header_moreMenuGotoVersionHistoryButton" : MessageLookupByLibrary.simpleMessage("前往版本历史"),
    "articlePage_header_moreMenuLoginButton" : MessageLookupByLibrary.simpleMessage("登录"),
    "articlePage_header_moreMenuRefreshButton" : MessageLookupByLibrary.simpleMessage("刷新"),
    "articlePage_header_moreMenuShowContentsButton" : MessageLookupByLibrary.simpleMessage("打开目录"),
    "articlePage_header_moreMenuWatchListButton" : m1,
    "articlePage_historyModeEditDisabledHint" : MessageLookupByLibrary.simpleMessage("你正在浏览历史版本，编辑被禁用"),
    "articlePage_shareSuffix" : MessageLookupByLibrary.simpleMessage("萌娘百科分享"),
    "articlePage_talkPageMissedHint" : MessageLookupByLibrary.simpleMessage("该页面讨论页未创建，是否要前往添加讨论话题？"),
    "articlePage_watchListOperatedHint" : m2,
    "indexPage_backHint" : MessageLookupByLibrary.simpleMessage("再次按下退出程序"),
    "settingsPage_title" : MessageLookupByLibrary.simpleMessage("設置"),
    "siteName" : MessageLookupByLibrary.simpleMessage("123"),
    "talkPagePrefix" : MessageLookupByLibrary.simpleMessage("讨论")
  };
}
