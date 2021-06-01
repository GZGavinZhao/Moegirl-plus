// ignore_for_file: non_constant_identifier_names

import 'package:date_format/date_format.dart';

// ignore: camel_case_types
class Language_zh_Hans {
  // 单词（可以作为变量名字面意思使用）
  var note = '注释';
  var contribution = '贡献';
  var category = '分类';
  var close = '关闭';
  var submit = '提交';
  var submitting = '提交中';
  var gallery = '画廊';
  var reload = '重新加载';
  var title = '标题';
  var link = '链接';
  var template = '模版';
  var sign = '签名';
  var strong = '加粗';
  var heimu = '黑幕';
  var list = '有序列表';
  var talk = '讨论';
  var loading = '加载中';
  var refresh = '刷新';
  var login = '登录';
  var contents = '目录';
  var publish = '发布';
  var published = '发布成功';
  var reply = '回复';
  var report = '举报';
  var undid = '撤销成功';
  var diff = '差异';
  var before = '之前';
  var after = '之后';
  var summary = '摘要';
  var check = '确定';
  var cancel = '取消';
  var history = '历史';

  // 双单词（可以作为变量名字面意思使用）
  var siteName = '萌娘百科';
  var netErr = '网络错误';
  var inputPlaceholder = '在此输入内容...';
  var pipeChar = '管道符';
  var delLine = '删除线';
  var colorText = '彩色字';
  var unorderedList = '无序列表';
  var level2Title = '二级标题';
  var level3Title = '三级标题';
  var noData = '暂无数据';
  var noImage = '暂无图片';
  var noComment = '暂无评论';
  var noSummary = '暂无摘要';
  var moegirlShare = '萌娘百科分享';
  var moreOptions = '更多选项';
  var showContents = '打开目录';
  var findNext = '查找下一个';
  var categorySearch = '分类搜索';
  var loadMore = '加载更多';
  var searchCategory = '搜索分类';
  var hotComment = '热门评论';
  var commentTotal = (int number) => '共$number条评论';
  var replyTotal = (int number) => '共$number条回复';
  var commentDeleted = '评论已删除';
  var undoReason = '撤销原因';
  var undoFail = '撤销失败';
  var execUndo = '执行撤销';
  var quickInsert = '快速插入';
  var userContribution = '用户贡献';
  
  // 其他（需要先确认内容）
  var hasNewVersionHint = '发现新版本，是否升级？';
  var colorTextPlaceholder = '颜色|文字';
  var loadArticleErrToUseCache = '加载文章失败，载入缓存';
  var loadArticleErr = '加载文章失败';
  var specialLinkUnsupported = '暂未适配特殊链接';
  var gettingImageUrl = '获取图片链接中...';
  var getImageUrlErr = '获取图片链接失败';
  var pageNameMissing = '该条目还未创建';
  var insufficientPermissions = '没有权限编辑该页面';
  var loadErrToClickRetry = '加载失败，点击重试';
  var allLoaded = '已经没有啦';
  var doubleBackToExit = '再次按下退出程序';
  var articleMissedHint = '该页面还未创建';
  var moreMenuEditButton = (String status) => {
    'permissionsChecking': '检查权限中',
    'addTheme': '添加话题',
    'full': '编辑此页',
    'disabled': '无权编辑此页'
  }[status];
  var pageVersionHistory = '页面版本历史';
  var findInPage = '页内查找';
  var categoryNameMappedPage = '这个分类对应的条目为';
  var emptyInCurrentCategory = '该分类下暂无条目';
  var subCategoryList = '子分类列表';
  var addCommentFail = '添加评论失败';
  var noSummaryOnCurrentEdit = '该编辑未填写摘要';

  // 长提示（基本上只会在一个地方使用）
  var nonAutoConfirmedHint = '您不是自动确认用户(编辑数超过10次且注册超过24小时)，无法在客户端进行编辑。要前往网页版进行编辑吗？';
  var notLoggedInHint = '未登录无法进行编辑，要前往登录界面吗？';
  var historyModeEditDisabledHint = '你正在浏览历史版本，编辑被禁用';
  var watchListOperatedHint = (bool isWatched) => '已${isWatched ? '移出' : '加入'}监视列表';
  var watchListOperateHint = (bool isExistsInWatchList) =>  '${isExistsInWatchList ? '移出' : '加入'}监视列表';
  var talkPageMissedHint = '该页面讨论页未创建，是否要前往添加讨论话题？';
  var bigPageSizeHint = '您搜索的分类下页面过多，搜索时间可能会较长';
  var categoryDuplicateAddHint = '请勿重复添加分类';
  var commentLoginHint = '未登录无法进行评论，是否前往登录？';
  var delCommentHint = (bool isReply) => '确定要删除自己的这条${isReply ? '回复' : '评论'}吗？';
  var reportHint = (bool isReply) => '确定要举报这条${isReply ? '回复' : '评论'}吗？';
  var reoprtedHint = '已举报，感谢您的反馈';
  var likeLoginHint = '未登录无法进行点赞，是否前往登录？';
  var replyLoginHint = '未登录无法进行回复，是否前往登录？';
  var editLeaveHint = '评论的内容不会保存，确认要关闭吗？';
  var inputUndoReasonPlease = '请输入撤销原因';

  // 特殊
  var comparesummaryPrefix = (String userName, String toRevId) => '撤销[[Special:Contributions/$userName|$userName]]（[[User_talk:$userName|讨论]]）的版本$toRevId';
  var quickSummaryList = ['进行破坏', '添加不实内容', '内容过于主观', '添加广告', '排版发生错乱'];

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
  var drawer_footer_exit = '退出程序';

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
  var imagePreviewerPage_permissionErrHint = '您未授予存储权限，图片无法保存';

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
  var settingsPage_title = '设置';
  var settingsPage_cleanCacheCheck = '确定要清除全部条目缓存吗？';
  var settingsPage_cleanCachekDone = '已清除全部缓存';
  var settingsPage_cleanHistoryCheck = '确定要清除全部浏览历史吗？';
  var settingsPage_cleanHistoryDone = '已清除全部浏览历史';
  var settingsPage_logoutCheck = '确定要登出吗？';
  var settingsPage_logouted = '已登出';
  var settingsPage_article = '条目';
  var settingsPage_heimuSwitch = '黑幕开关';
  var settingsPage_heimuSwitchHint = '关闭后黑幕将默认为刮开状态';
  var settingsPage_stopAudioOnLeave = '停止旧页面背景媒体';
  var settingsPage_stopAudioOnLeaveHint = '打开新条目时停止上一个条目中正在播放的音频和视频';
  var settingsPage_interface = '界面';
  var settingsPage_changeTheme = '更换主题';
  var settingsPage_changeLanguage = '切换语言';
  var settingsPage_cache = '缓存';
  var settingsPage_cachePriority = '缓存优先模式';
  var settingsPage_cachePriorityHint = '如果有条目有缓存将优先使用';
  var settingsPage_cleanCache = '清除条目缓存';
  var settingsPage_cleanReadingHistory = '清除浏览历史';
  var settingsPage_account = '账户';
  var settingsPage_loginToggle = (bool isLoggedIn) => isLoggedIn ? '登出' : '登录';
  var settingsPage_other = '其他';
  var settingsPage_about = '关于';
  var settingsPage_checkNewVersion = '检查新版本';
  var settingsPage_noNewVersion = '当前为最新版本';

  var settingsPage_showAboutDialog_title = '关于';
  var settingsPage_showAboutDialog_version = '版本';
  var settingsPage_showAboutDialog_updateDate = '更新日期';
  var settingsPage_showAboutDialog_development = '开发';
  var settingsPage_showAboutDialog_close = '关闭';

  var settingsPage_showLanguageSelectionDialog_title = '选择语言';
  var settingsPage_showLanguageSelectionDialog_close = '取消';
  var settingsPage_showLanguageSelectionDialog_check = '确定';
  var settingsPage_showLanguageSelectionDialog_changedHint = '修改语言重启后生效';

  var settingsPage_showThemeSelectionDialog_title = '选择主题';
  var settingsPage_showThemeSelectionDialog_close = '取消';
  var settingsPage_showThemeSelectionDialog_check = '确定';
}