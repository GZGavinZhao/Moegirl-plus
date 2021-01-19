// ignore_for_file: non_constant_identifier_names

import 'package:date_format/date_format.dart';
import 'package:moegirl_plus/language/zh_hans.dart';

// ignore: camel_case_types
class Language_zh_Hant implements Language_zh_Hans {
  // 共用 ----------------------------------------------------------------
  var siteName = '萌娘百科';
  var talkPagePrefix = '討論';
  var close = '關閉';
  var category = '分類';
  var netErr = '網路錯誤';
  var submitting = '提交中...';
  var hasNewVersionHint = '發現新版本，是否升級？';

  // 组件 ----------------------------------------------------------------

  // 文章
  var articleViewCom_loadArticleErrToUseCache = '載入文章失敗，載入快取';
  var articleViewCom_loadArticleErr = '載入文章失敗';
  var articleViewCom_specialLinkUnsupported = '暫未適配特殊連結';
  var articleViewCom_svgImageUnsupported = '無法預覽SVG圖片';
  var articleViewCom_gettingImageUrl = '獲取圖片連結中...';
  var articleViewCom_getImageUrlErr = '獲取圖片連結失敗';
  var articleViewCom_pageNameMissing = '該條目還未建立';
  var articleViewCom_insufficientPermissions = '沒有許可權編輯該頁面';
  var articleViewCom_NotLoggedInHint = '未登入無法進行編輯，要前往登入介面嗎？';
  var articleViewCom_reload = '重新載入';
  var articleViewCom_noteDialog_title = '註釋';

  // 维基编辑器
  var wikiEditorCom_newSectionTitle = '標題';
  var wikiEditorCom_inputPlaceholder = '在此輸入內容...';
  var wikiEditorCom_link = '連結';
  var wikiEditorCom_template = '模版';
  var wikiEditorCom_pipeChar = '管道符';
  var wikiEditorCom_sign = '簽名';
  var wikiEditorCom_strong = '加粗';
  var wikiEditorCom_delLine = '刪除線';
  var wikiEditorCom_heimu = '黑幕';
  var wikiEditorCom_colorText = '彩色字';
  var wikiEditorCom_ColorTextPlaceholder = '顏色|文字';
  var wikiEditorCom_unorderedList = '無序列表';
  var wikiEditorCom_list = '有序列表';
  var wikiEditorCom_level2Title = '二級標題';
  var wikiEditorCom_level3Title = '三級標題';

  // 无限加载列表尾部
  var infinityListFooterCom_errorText = '載入失敗，點選重試';
  var infinityListFooterCom_allLoadedText = '已經沒有啦';
  var infinityListFooterCom_emptyText = '暫無資料';

  // 页面 ----------------------------------------------------------------
  
  // 首页
  var indexPage_backHint = '再次按下退出程式';

  // 条目
  var articlePage_historyModeEditDisabledHint = '你正在瀏覽歷史版本，編輯被禁用';
  var articlePage_articleMissedHint = '該頁面還未建立';
  var articlePage_watchListOperatedHint = (bool isWatched) => '已${isWatched ? '移除' : '加入'}監視列表';
  var articlePage_talkPageMissedHint = '該頁面討論頁未建立，是否要前往新增討論話題？';
  var articlePage_shareSuffix = '萌娘百科分享';
  var articlePage_commentButtonLoadingHint = '載入中';

  var articlePage_header_moreButtonTooltip = '更多選項';
  var articlePage_header_moreMenuRefreshButton = '重新整理';
  var articlePage_header_moreMenuEditButton = (String status) => {
    'permissionsChecking': '檢查許可權中',
    'addTheme': '新增話題',
    'full': '編輯此頁',
    'disabled': '無權編輯此頁'
  }[status];
  var articlePage_header_moreMenuLoginButton = '登入';
  var articlePage_header_moreMenuWatchListButton = (bool isExistsInWatchList) =>  '${isExistsInWatchList ? '移出' : '加入'}監視列表';
  var articlePage_header_moreMenuGotoTalkPageButton = '前往討論頁';
  var articlePage_header_moreMenuGotoVersionHistoryButton = '前往版本歷史';
  var articlePage_header_moreMenuGotoShareButton = '分享';
  var articlePage_header_moreMenuShowContentsButton = '開啟目錄';

  var articlePage_contents_title = '目錄';

  // 分类
  var categoryPage_categoryNameToPage = '這個分類對應的條目為：';
  var categoryPage_empty = '該分類下暫無條目';

  var categoryPage_subCategoryList_title = '子分類列表';
  var categoryPage_subCategoryList_loadMore = '載入更多';

  var categoryPage_item_noImage = '暫無圖片';

  // 评论
  var commentPage_submitted = '釋出成功';
  var commentPage_submitErr = '新增評論失敗';
  var commentPage_title = '評論';
  var commentPage_hotComment = '熱門評論';
  var commentPage_commentTotal = (int number) => '共$number條評論';
  var commentPage_empty = '暫無評論';

  var commentPage_item_delCommentCheck = (bool isReply) => '確定要刪除自己的這條${isReply ? '回覆' : '評論'}嗎？';
  var commentPage_item_commentDeleted = '評論已刪除';
  var commentPage_item_submitted = '釋出成功';
  var commentPage_item_reportCheck = (bool isReply) => '確定要舉報這條${isReply ? '回覆' : '評論'}嗎？';
  var commentPage_item_reoprted = '已舉報，感謝您的反饋';
  var commentPage_item_replay = '回覆';
  var commentPage_item_report = '舉報';
  var commentPage_item_replayTotal = (int number) => '共$number條回覆';
  var commentPage_item_ = '';

  var commentPage_showCommentEditor_publish = '釋出';
  var commentPage_showCommentEditor_leavelHint = '評論的內容不會儲存，確認要關閉嗎？';
  var commentPage_showCommentEditor_actionName = (bool isReply) => isReply ? '回覆' : '評論';

  // 回复
  var replayPage_published = '釋出成功';
  var replayPage_title = '回覆';
  var replayPage_replayTotal = (int number) => '共$number條回覆';
  var replayPage_empty = '已經沒有啦';

  // 差异对比
  var comparePage_summaryPrefix = (String userName, String toRevId) => '撤銷[[Special:Contributions/$userName|$userName]]（[[User_talk:$userName|討論]]）的版本$toRevId';
  var comparePage_undoReason = '撤銷原因：';
  var comparePage_undid = '執行撤銷成功';
  var comparePage_undoFail = '撤銷失敗';
  var comparePage_title = '差異';
  var comparePage_before = '之前';
  var comparePage_after = '之後';
  var comparePage_reload = '重新載入';

  var comparePage_diffContent_talk = '討論';
  var comparePage_diffContent_noSummary = '暫無編輯摘要';
  var comparePage_diffContent_summary = '摘要';

  var comparePage_showUndoDialog_quickSummaryList = ['進行破壞', '新增不實內容', '內容過於主觀', '新增廣告', '排版發生錯亂'];
  var comparePage_showUndoDialog_title = '執行撤銷';
  var comparePage_showUndoDialog_inputPlaceholder = '請輸入撤銷原因';
  var comparePage_showUndoDialog_quickInsert = '快速插入';
  var comparePage_showUndoDialog_cancel = '取消';
  var comparePage_showUndoDialog_submit = '提交';

  var contributionPage_title = '使用者貢獻';
  var contributionPage_item_noSummary = '該編輯未填寫摘要';
  var contributionPage_item_diff = '差異';
  var contributionPage_item_history = '歷史';

  // 抽屉
  var drawer_header_welcome = (String userName) => '歡迎你，$userName';
  var drawer_header_loginHint = '登入/加入萌娘百科';

  var drawer_body_helpTitle = '操作提示';
  var drawer_body_helpContent = [
    '1. 左滑開啟抽屜',
    '2. 條目頁右滑開啟目錄',
    // '3. 條目內容中長按b站播放器按鈕跳轉至b站對應影片頁(當然前提是手機裡有b站app)',
    // '4. 左右滑動影片播放器小窗可以關閉影片'
  ].join('\n');
  var drawer_body_talk = '討論版';
  var drawer_body_recentChanges = '最近更改';
  var drawer_body_history = '瀏覽歷史';
  var drawer_body_help = '操作提示';
  var drawer_body_nightTheme = (bool isNight) => (isNight ? '關閉' : '開啟') + '黑夜模式';

  var drawer_footer_settings = '設定';
  var drawer_footer_exit = '退出程式';

  // 编辑
  var editPage_summaryNoSection = '未指定章節';
  var editPage_noSectionHint = '請在頂部新增一個標題';
  var editPage_noContentHint = '內容不能為空';
  var editPage_submitted = '編輯成功';
  var editPage_submitEditconflict = '出現編輯衝突，請複製編輯的內容後再次進入編輯介面，並檢查差異';
  var editPage_submitProtectedpage = '沒有許可權編輯此頁面';
  var editPage_submitReadonly = '目前資料庫處於鎖定狀態，無法編輯';
  var editPage_submitUnkownErr = '未知錯誤';
  var editPage_netErr = '網路錯誤，請重試';
  var editPage_leaveCheck = '確定要退出編輯頁面嗎？您的編輯不會被儲存。';
  var editPage_editFullTitle = '編輯';
  var editPage_editSectionTitle = '編輯段落';
  var editPage_editNewTitle = '新建';
  var editPage_wikiText = '維基文字';
  var editPage_preview = '預覽檢視';

  var editPage_preview_reload = '重新載入';

  var editPage_wikiEidting_reload = '重新載入';

  var editPage_showSubmitDialog_quickSummaryList = ['修飾語句', '修正筆誤', '內容擴充', '排版'];
  var editPage_showSubmitDialog_title = '提交編輯';
  var editPage_showSubmitDialog_inputPlaceholder = '請輸入摘要';
  var editPage_showSubmitDialog_quickInsert = '快速摘要';
  var editPage_showSubmitDialog_close = '取消';
  var editPage_showSubmitDialog_submit = '提交';

  // 页面编辑历史
  var editHistoryPage_title = '版本歷史';

  var editHistoryPage_item_talk = '討論';
  var editHistoryPage_item_noSummary = '該編輯未填寫摘要';
  var editHistoryPage_item_current = '當前';
  var editHistoryPage_item_last = '之前';

  // 浏览历史
  var historyPage_todayDatePrefix = '今天';
  var historyPage_yesterdayDatePrefix = '昨天';
  var historyPage_cleanCheck = '確定要清空歷史記錄嗎？';
  var historyPage_title = '瀏覽歷史';
  var historyPage_noData = '暫無記錄';

  // 图片查看器
  var imagePreviewerPage_successHint = '圖片已儲存至相簿';
  var imagePreviewerPage_failHint = '圖片儲存失敗';

  // 登录
  var loginPage_userNameEmptyHint = '使用者名稱不能為空';
  var loginPage_passwordEmptyHint = '密碼不能為空';
  var loginPage_logging = '登入中...';
  var loginPage_loggedIn = '登入成功';
  var loginPage_slogan = '萌娘百科，萬物皆可萌的百科全書！';
  var loginPage_userName = '使用者名稱';
  var loginPage_password = '密碼';
  var loginPage_login = '登入';
  var loginPage_registerHint = '還沒有萌百帳號？點選前往官網註冊';

  // 通知
  var notificationPage_markAllAsReaded = '標記所有為已讀';
  var notificationPage_title = '通知';

  // 最近更改
  var recentChangesPage_chineseWeeks = ['', '一', '二', '三', '四', '五', '六', '日'];
  var recentChangesPage_dateTitle = (int year, int month, int day, String week) => '$year年$month月$day日（星期$week）';
  var recentChangesPage_toggleMode = (bool isWatchListMode) => '切換為${isWatchListMode ? '監視列表' : '全部列表'}模式';
  var recentChangesPage_title = '最近更改';

  var recentChangesPage_item_new = '新';
  var recentChangesPage_item_log = '日誌';
  var recentChangesPage_item_noSummary = '該編輯未填寫摘要';
  var recentChangesPage_item_toggleDetail = (bool visibleEditDetails, int totalNumberOfEdit) => (visibleEditDetails ? '收起' : '展開') + '詳細記錄(共$totalNumberOfEdit次編輯)';
  var recentChangesPage_item_talk = '討論';
  var recentChangesPage_item_contribution = '貢獻';
  
  var recentChangesPage_detailItem_new = '新';
  var recentChangesPage_detailItem_log = '日誌';
  var recentChangesPage_detailItem_noSummary = '該編輯未填寫摘要';
  var recentChangesPage_detailItem_talk = '討論';
  var recentChangesPage_detailItem_contribution = '貢獻';
  var recentChangesPage_detailItem_current = '當前';
  var recentChangesPage_detailItem_last = '之前';
  
  var recentChangesPage_showOptionsDialog_title = '列表選項';
  var recentChangesPage_showOptionsDialog_timeRange = '時間範圍';
  var recentChangesPage_showOptionsDialog_WithinDay = '天內';
  var recentChangesPage_showOptionsDialog_maxShownNumber = '最多顯示數';
  var recentChangesPage_showOptionsDialog_number = '條';
  var recentChangesPage_showOptionsDialog_changeType = '更改型別';
  var recentChangesPage_showOptionsDialog_myEdit = '我的編輯';
  var recentChangesPage_showOptionsDialog_robot = '機器人';
  var recentChangesPage_showOptionsDialog_microEdit = '小編輯';
  var recentChangesPage_showOptionsDialog_check = '確定';

  // 搜索
  var searchPage_appBarBody_inputPlaceholder = '搜尋萌娘百科...';

  var searchPage_recentSearch_delSingleRecordCheck = '確定要刪除這條搜尋記錄嗎？';
  var searchPage_recentSearch_delAllRecordCheck = '確定要刪除全部搜尋記錄嗎？';
  var searchPage_recentSearch_noData = '暫無搜尋記錄';
  var searchPage_recentSearch_title = '最近搜尋';

  var searchPage_searchHint_loadFaild = '載入失敗';
  var searchPage_searchHint_loading = '載入中...';

  // 搜索结果
  var searchResultPage_title = '搜尋';
  var searchResultPage_resultTotal = (int resultTotal) => '共搜尋到$resultTotal條結果。';
  var searchResultPage_netErr = '載入失敗，點選重試';
  var searchResultPage_allLoaded = '已經沒有啦';

  var searchResultPage_item_redirectTitle = (String title) => '「$title」指向該頁面';
  var searchResultPage_item_sectionTitle = (String title) => '該頁面有名為“$title”的章節';
  var searchResultPage_item_foundFromCategories = '匹配自頁面分類';
  var searchResultPage_item_noContent = '頁面內貌似沒有內容呢...';
  var searchResultPage_item_dateFormat = ['最後更新於：', yyyy, '年', mm, '月', dd, '日'];

  // 设置
  var settingsPage_title = '設定';
  var settingsPage_cleanCacheCheck = '確定要清除全部條目快取嗎？';
  var settingsPage_cleanCachekDone = '已清除全部快取';
  var settingsPage_cleanHistoryCheck = '確定要清除全部瀏覽歷史嗎？';
  var settingsPage_cleanHistoryDone = '已清除全部瀏覽歷史';
  var settingsPage_logoutCheck = '確定要登出嗎？';
  var settingsPage_logouted = '已登出';
  var settingsPage_article = '條目';
  var settingsPage_heimuSwitch = '黑幕開關';
  var settingsPage_heimuSwitchHint = '關閉後黑幕將預設為刮開狀態';
  var settingsPage_stopAudioOnLeave = '停止舊頁面背景媒體';
  var settingsPage_stopAudioOnLeaveHint = '開啟新條目時停止舊條目上的音訊和影片';
  var settingsPage_interface = '介面';
  var settingsPage_changeTheme = '更換主題';
  var settingsPage_changeLanguage = '切換語言';
  var settingsPage_cache = '快取';
  var settingsPage_cachePriority = '快取優先模式';
  var settingsPage_cachePriorityHint = '如果有條目有快取將優先使用';
  var settingsPage_cleanCache = '清除條目快取';
  var settingsPage_cleanReadingHistory = '清除瀏覽歷史';
  var settingsPage_account = '賬戶';
  var settingsPage_loginToggle = (bool isLoggedIn) => isLoggedIn ? '登出' : '登入';
  var settingsPage_other = '其他';
  var settingsPage_about = '關於';

  var settingsPage_showAboutDialog_title = '關於';
  var settingsPage_showAboutDialog_version = '版本';
  var settingsPage_showAboutDialog_updateDate = '更新日期';
  var settingsPage_showAboutDialog_development = '開發';
  var settingsPage_showAboutDialog_close = '關閉';

  var settingsPage_showLanguageSelectionDialog_title = '選擇語言';
  var settingsPage_showLanguageSelectionDialog_close = '取消';
  var settingsPage_showLanguageSelectionDialog_check = '確定';

  var settingsPage_showThemeSelectionDialog_title = '選擇主題';
  var settingsPage_showThemeSelectionDialog_close = '取消';
  var settingsPage_showThemeSelectionDialog_check = '確定';
}