// ignore_for_file: non_constant_identifier_names

// ignore: camel_case_types
import 'package:date_format/date_format.dart';

class Language_zh_Hans {
  // 共用 ----------------------------------------------------------------
  var siteName = '萌娘百科';
  var talkPagePrefix = '讨论';
  var close = '关闭';
  var category = '分类';
  var netErr = '网络错误';
  var submitting = '提交中...';

  // 组件 ----------------------------------------------------------------

  // 文章
  var articleViewCom_loadArticleErrToUseCache = '加载文章失败，载入缓存';
  var articleViewCom_loadArticleErr = '加载文章失败';
  var articleViewCom_specialLinkUnsupported = '暂未适配特殊链接';
  var articleViewCom_svgImageUnsupported = '无法预览SVG图片';
  var articleViewCom_gettingImageUrl = '获取图片链接中...';
  var articleViewCom_getImageUrlErr = '获取图片链接失败';
  var articleViewCom_pageNameMissing = '该条目还未创建';
  var articleViewCom_insufficientPermissions = '没有权限编辑该页面';
  var articleViewCom_NotLoggedInHint = '未登录无法进行编辑，要前往登录界面吗？';
  var articleViewCom_reload = '重新加载';
  var articleViewCom_noteDialog_title = '注释';

  // 维基编辑器
  var wikiEditorCom_newSectionTitle = '标题';
  var wikiEditorCom_inputPlaceholder = '在此输入内容...';
  var wikiEditorCom_link = '链接';
  var wikiEditorCom_template = '模版';
  var wikiEditorCom_pipeChar = '管道符';
  var wikiEditorCom_sign = '签名';
  var wikiEditorCom_strong = '加粗';
  var wikiEditorCom_delLine = '删除线';
  var wikiEditorCom_heimu = '黑幕';
  var wikiEditorCom_colorText = '彩色字';
  var wikiEditorCom_ColorTextPlaceholder = '颜色|文字';
  var wikiEditorCom_unorderedList = '无序列表';
  var wikiEditorCom_list = '有序列表';
  var wikiEditorCom_level2Title = '二级标题';
  var wikiEditorCom_level3Title = '三级标题';

  // 无限加载列表尾部
  var infinityListFooterCom_errorText = '加载失败，点击重试';
  var infinityListFooterCom_allLoadedText = '已经没有啦';
  var infinityListFooterCom_emptyText = '暂无数据';

  // 页面 ----------------------------------------------------------------
  
  // 首页
  var indexPage_backHint = '再次按下退出程序';

  // 条目
  var articlePage_historyModeEditDisabledHint = '你正在浏览历史版本，编辑被禁用';
  var articlePage_articleMissedHint = '该页面还未创建';
  var articlePage_watchListOperatedHint = (bool isWatched) => '已${isWatched ? '移除' : '加入'}监视列表';
  var articlePage_talkPageMissedHint = '该页面讨论页未创建，是否要前往添加讨论话题？';
  var articlePage_shareSuffix = '萌娘百科分享';
  var articlePage_commentButtonLoadingHint = '加载中';

  var articlePage_header_moreButtonTooltip = '更多选项';
  var articlePage_header_moreMenuRefreshButton = '刷新';
  var articlePage_header_moreMenuEditButton = (String status) => {
    'permissionsChecking': '检查权限中',
    'addTheme': '添加话题',
    'full': '编辑此页',
    'disabled': '无权编辑此页'
  }[status];
  var articlePage_header_moreMenuLoginButton = '登录';
  var articlePage_header_moreMenuWatchListButton = (bool isExistsInWatchList) =>  '${isExistsInWatchList ? '移出' : '加入'}监视列表';
  var articlePage_header_moreMenuGotoTalkPageButton = '前往讨论页';
  var articlePage_header_moreMenuGotoVersionHistoryButton = '前往版本历史';
  var articlePage_header_moreMenuGotoShareButton = '分享';
  var articlePage_header_moreMenuShowContentsButton = '打开目录';

  var articlePage_contents_title = '目录';

  // 分类
  var categoryPage_categoryNameToPage = '这个分类对应的条目为：';
  var categoryPage_empty = '该分类下暂无条目';

  var categoryPage_subCategoryList_title = '子分类列表';
  var categoryPage_subCategoryList_loadMore = '加载更多';

  var categoryPage_item_noImage = '暂无图片';

  // 评论
  var commentPage_submitted = '发布成功';
  var commentPage_submitErr = '添加评论失败';
  var commentPage_title = '评论';
  var commentPage_hotComment = '热门评论';
  var commentPage_commentTotal = (int number) => '共$number条评论';
  var commentPage_empty = '暂无评论';

  var commentPage_item_delCommentCheck = (bool isReply) => '确定要删除自己的这条${isReply ? '回复' : '评论'}吗？';
  var commentPage_item_commentDeleted = '评论已删除';
  var commentPage_item_submitted = '发布成功';
  var commentPage_item_reportCheck = (bool isReply) => '确定要举报这条${isReply ? '回复' : '评论'}吗？';
  var commentPage_item_reoprted = '已举报，感谢您的反馈';
  var commentPage_item_replay = '回复';
  var commentPage_item_report = '举报';
  var commentPage_item_replayTotal = (int number) => '共$number条回复';
  var commentPage_item_ = '';

  var commentPage_showCommentEditor_publish = '发布';
  var commentPage_showCommentEditor_leavelHint = '评论的内容不会保存，确认要关闭吗？';
  var commentPage_showCommentEditor_actionName = (bool isReply) => isReply ? '回复' : '评论';

  // 回复
  var replayPage_published = '发布成功';
  var replayPage_title = '回复';
  var replayPage_replayTotal = (int number) => '共$number条回复';
  var replayPage_empty = '已经没有啦';

  // 差异对比
  var comparePage_summaryPrefix = (String userName, String toRevId) => '撤销[[Special:Contributions/$userName|$userName]]（[[User_talk:$userName|讨论]]）的版本$toRevId';
  var comparePage_undoReason = '撤销原因：';
  var comparePage_undid = '执行撤销成功';
  var comparePage_undoFail = '撤销失败';
  var comparePage_title = '差异';
  var comparePage_before = '之前';
  var comparePage_after = '之后';
  var comparePage_reload = '重新加载';

  var comparePage_diffContent_talk = '讨论';
  var comparePage_diffContent_noSummary = '暂无编辑摘要';
  var comparePage_diffContent_summary = '摘要';

  var comparePage_showUndoDialog_quickSummaryList = ['进行破坏', '添加不实内容', '内容过于主观', '添加广告', '排版发生错乱'];
  var comparePage_showUndoDialog_title = '执行撤销';
  var comparePage_showUndoDialog_inputPlaceholder = '请输入撤销原因';
  var comparePage_showUndoDialog_quickInsert = '快速插入';
  var comparePage_showUndoDialog_cancel = '取消';
  var comparePage_showUndoDialog_submit = '提交';

  var contributionPage_title = '用户贡献';
  var contributionPage_item_noSummary = '该编辑未填写摘要';
  var contributionPage_item_diff = '差异';
  var contributionPage_item_history = '历史';

  // 抽屉
  var drawer_header_welcome = (String userName) => '欢迎你，$userName';
  var drawer_header_loginHint = '登录/加入萌娘百科';

  var drawer_body_helpTitle = '操作提示';
  var drawer_body_helpContent = [
    '1. 左滑开启抽屉',
    '2. 条目页右滑开启目录',
    // '3. 条目内容中长按b站播放器按钮跳转至b站对应视频页(当然前提是手机里有b站app)',
    // '4. 左右滑动视频播放器小窗可以关闭视频'
  ].join('\n');
  var drawer_body_talk = '讨论版';
  var drawer_body_recentChanges = '最近更改';
  var drawer_body_history = '浏览历史';
  var drawer_body_help = '操作提示';
  var drawer_body_nightTheme = (bool isNight) => (isNight ? '关闭' : '开启') + '黑夜模式';

  var drawer_footer_settings = '设置';
  var drawer_footer_exit = '退出应用';

  // 编辑
  var editPage_summaryNoSection = '未指定章节';
  var editPage_noSectionHint = '请在顶部添加一个标题';
  var editPage_noContentHint = '内容不能为空';
  var editPage_submitted = '编辑成功';
  var editPage_submitEditconflict = '出现编辑冲突，请复制编辑的内容后再次进入编辑界面，并检查差异';
  var editPage_submitProtectedpage = '没有权限编辑此页面';
  var editPage_submitReadonly = '目前数据库处于锁定状态，无法编辑';
  var editPage_submitUnkownErr = '未知错误';
  var editPage_netErr = '网络错误，请重试';
  var editPage_leaveCheck = '确定要退出编辑页面吗？您的编辑不会被保存。';
  var editPage_editFullTitle = '编辑';
  var editPage_editSectionTitle = '编辑段落';
  var editPage_editNewTitle = '新建';
  var editPage_wikiText = '维基文本';
  var editPage_preview = '预览视图';

  var editPage_preview_reload = '重新加载';

  var editPage_wikiEidting_reload = '重新加载';

  var editPage_showSubmitDialog_quickSummaryList = ['修饰语句', '修正笔误', '内容扩充', '排版'];
  var editPage_showSubmitDialog_title = '提交编辑';
  var editPage_showSubmitDialog_inputPlaceholder = '请输入摘要';
  var editPage_showSubmitDialog_quickInsert = '快速摘要';
  var editPage_showSubmitDialog_close = '取消';
  var editPage_showSubmitDialog_submit = '提交';

  // 页面编辑历史
  var editHistoryPage_title = '版本历史';

  var editHistoryPage_item_talk = '讨论';
  var editHistoryPage_item_noSummary = '该编辑未填写摘要';
  var editHistoryPage_item_current = '当前';
  var editHistoryPage_item_last = '之前';

  // 浏览历史
  var historyPage_todayDatePrefix = '今天';
  var historyPage_yesterdayDatePrefix = '昨天';
  var historyPage_cleanCheck = '确定要清空历史记录吗？';
  var historyPage_title = '浏览历史';
  var historyPage_noData = '暂无记录';

  // 图片查看器
  var imagePreviewerPage_successHint = '图片已保存至相册';
  var imagePreviewerPage_failHint = '图片保存失败';

  // 登录
  var loginPage_userNameEmptyHint = '用户名不能为空';
  var loginPage_passwordEmptyHint = '密码不能为空';
  var loginPage_logging = '登录中...';
  var loginPage_loggedIn = '登录成功';
  var loginPage_slogan = '萌娘百科，万物皆可萌的百科全书！';
  var loginPage_userName = '用户名';
  var loginPage_password = '密码';
  var loginPage_login = '登录';
  var loginPage_registerHint = '还没有萌百帐号？点击前往官网注册';

  // 通知
  var notificationPage_markAllAsReaded = '标记所有为已读';
  var notificationPage_title = '通知';

  // 最近更改

  var recentChangesPage_chineseWeeks = ['', '一', '二', '三', '四', '五', '六', '日'];
  var recentChangesPage_dateTitle = (int year, int month, int day, String week) => '$year年$month月$day日（星期$week）';
  var recentChangesPage_toggleMode = (bool isWatchListMode) => '切换为${isWatchListMode ? '监视列表' : '全部列表'}模式';
  var recentChangesPage_title = '最近更改';

  var recentChangesPage_item_new = '新';
  var recentChangesPage_item_log = '日志';
  var recentChangesPage_item_noSummary = '该编辑未填写摘要';
  var recentChangesPage_item_toggleDetail = (bool visibleEditDetails, int totalNumberOfEdit) => (visibleEditDetails ? '收起' : '展开') + '详细记录(共$totalNumberOfEdit次编辑)';
  var recentChangesPage_item_talk = '讨论';
  var recentChangesPage_item_contribution = '贡献';
  
  var recentChangesPage_detailItem_new = '新';
  var recentChangesPage_detailItem_log = '日志';
  var recentChangesPage_detailItem_noSummary = '该编辑未填写摘要';
  var recentChangesPage_detailItem_talk = '讨论';
  var recentChangesPage_detailItem_contribution = '贡献';
  var recentChangesPage_detailItem_current = '当前';
  var recentChangesPage_detailItem_last = '之前';
  
  var recentChangesPage_showOptionsDialog_title = '列表选项';
  var recentChangesPage_showOptionsDialog_timeRange = '时间范围';
  var recentChangesPage_showOptionsDialog_WithinDay = '天内';
  var recentChangesPage_showOptionsDialog_maxShownNumber = '最多显示数';
  var recentChangesPage_showOptionsDialog_number = '条';
  var recentChangesPage_showOptionsDialog_changeType = '更改类型';
  var recentChangesPage_showOptionsDialog_myEdit = '我的编辑';
  var recentChangesPage_showOptionsDialog_robot = '机器人';
  var recentChangesPage_showOptionsDialog_microEdit = '小编辑';
  var recentChangesPage_showOptionsDialog_check = '确定';

  // 搜索
  var searchPage_appBarBody_inputPlaceholder = '搜索萌娘百科...';

  var searchPage_recentSearch_delSingleRecordCheck = '确定要删除这条搜索记录吗？';
  var searchPage_recentSearch_delAllRecordCheck = '确定要删除全部搜索记录吗？';
  var searchPage_recentSearch_noData = '暂无搜索记录';
  var searchPage_recentSearch_title = '最近搜索';

  var searchPage_searchHint_loadFaild = '加载失败';
  var searchPage_searchHint_loading = '加载中...';

  // 搜索结果
  var searchResultPage_title = '搜索';
  var searchResultPage_resultTotal = (int resultTotal) => '共搜索到$resultTotal条结果。';
  var searchResultPage_netErr = '加载失败，点击重试';
  var searchResultPage_allLoaded = '已经没有啦';

  var searchResultPage_item_redirectTitle = (String title) => '「$title」指向该页面';
  var searchResultPage_item_sectionTitle = (String title) => '该页面有名为“$title”的章节';
  var searchResultPage_item_foundFromCategories = '匹配自页面分类';
  var searchResultPage_item_noContent = '页面内貌似没有内容呢...';
  var searchResultPage_item_dateFormat = ['最后更新于：', yyyy, '年', mm, '月', dd, '日'];

  // 设置
  // var 
  
  var settingsPage_title = '设置';
}