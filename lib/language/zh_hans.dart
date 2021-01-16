// ignore_for_file: non_constant_identifier_names

// ignore: camel_case_types
class Language_zh_Hans {
  // 共用
  var siteName = '萌娘百科';
  var talkPagePrefix = '讨论';
  var close = '关闭';
  var category = '分类';
  var netErr = '网络错误';
  var submitting = '提交中...';

  // 组件
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

  // 页面
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

  // 设置
  var settingsPage_title = '设置';
}