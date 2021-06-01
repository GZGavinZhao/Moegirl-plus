// ignore_for_file: non_constant_identifier_names

import 'package:date_format/date_format.dart';
import 'package:moegirl_plus/language/zh_hans.dart';

// ignore: camel_case_types
class Language_zh_Hant implements Language_zh_Hans {
  // 单词（可以作为变量名字面意思使用）
  var note = '註釋';
  var contribution = '貢獻';
  var category = '分類';
  var close = '關閉';
  var submit = '提交';
  var submitting = '提交中';
  var gallery = '畫廊';
  var reload = '重新載入';
  var title = '標題';
  var link = '連結';
  var template = '模版';
  var sign = '簽名';
  var strong = '加粗';
  var heimu = '黑幕';
  var list = '有序列表';
  var talk = '討論';
  var loading = '載入中';
  var refresh = '重新整理';
  var login = '登入';
  var contents = '目錄';
  var publish = '釋出';
  var published = '釋出成功';
  var reply = '回覆';
  var report = '舉報';
  var undid = '撤銷成功';
  var diff = '差異';
  var before = '之前';
  var current = '當前';
  var after = '之後';
  var summary = '摘要';
  var check = '確定';
  var cancel = '取消';
  var history = '歷史';
  var settings = '設定';
  var edited = '編輯成功';
  var edit = '編輯';
  var create = '新建';
  var today = '今天';
  var yesterday = '昨天';
  var logging = '登入中';
  var password = '密碼';
  var notification = '通知';
  var new_ = '新';
  var log = '日誌';
  var number = '條';
  var robot = '機器人';
  var search = '搜尋';
  var logout = '登出';
  var logouted = '已登出';
  var interface = '介面';
  var cache = '快取';
  var account = '賬戶';
  var other = '其他';
  var about = '關於';
  var version = '版本';
  var development = '開發';

  
  // 词组（可以作为变量名字面意思使用）
  var siteName = '萌娘百科';
  var netErr = '網路錯誤';
  var inputPlaceholder = '在此輸入內容...';
  var pipeChar = '管道符';
  var delLine = '刪除線';
  var colorText = '彩色字';
  var unorderedList = '無序列表';
  var level2Title = '二級標題';
  var level3Title = '三級標題';
  var noData = '暫無資料';
  var noImage = '暫無圖片';
  var noComment = '暫無評論';
  var noSummary = '暫無摘要';
  var moegirlShare = '萌娘百科分享';
  var moreOptions = '更多選項';
  var showContents = '開啟目錄';
  var findNext = '查詢下一個';
  var categorySearch = '分類搜尋';
  var loadMore = '載入更多';
  var searchCategory = '搜尋分類';
  var hotComment = '熱門評論';
  var commentTotal = (int number) => '共$number條評論';
  var replyTotal = (int number) => '共$number條回覆';
  var commentDeleted = '評論已刪除';
  var undoReason = '撤銷原因';
  var undoFail = '撤銷失敗';
  var execUndo = '執行撤銷';
  var quickInsert = '快速插入';
  var userContribution = '使用者貢獻';
  var operationHelp = '操作提示';
  var talkPage = '討論版';
  var recentChanges = '最近更改';
  var browseHistory = '瀏覽歷史';
  var exitApp = '退出程式';
  var unkownErr = '未知錯誤';
  var editSection = '編輯段落';
  var wikiText = '維基文字';
  var previewView = '預覽檢視';
  var submitEdit = '提交編輯';
  var versionHistory = '版本歷史';
  var noRecord = '暫無記錄';
  var loggedIn = '登入成功';
  var userName = '使用者名稱';
  var listOptions = '列表選項';
  var timeRange = '時間範圍';
  var withinDay = '天內';
  var noMore = '已經沒有啦';
  var findInPage = '頁內查詢';
  var subCategoryList = '子分類列表';
  var addCommentFail = '新增評論失敗';
  var getImageUrlFail = '獲取圖片連結失敗';
  var imageSaveFail = '圖片儲存失敗';
  var maxShownNumber = '最多顯示數';
  var changeType = '更改型別';
  var myEdit = '我的編輯';
  var microEdit = '小編輯';
  var searchInMoegirl = '搜尋萌娘百科';
  var recentSearch = '最近搜尋';
  var loadFail = '載入失敗';
  var noSearchRecord = '暫無搜尋記錄';
  var article = '條目';
  var heimuSwitch = '黑幕開關';
  var changeTheme = '更換主題';
  var changeLanguage = '切換語言';
  var cachePriorityMode = '快取優先模式';
  var cleanArticleCache = '清除條目快取';
  var cleanBrowseHistory = '清除瀏覽歷史';
  var checkNewVersion = '檢查新版本';
  var currentIsVersion = '當前為最新版本';
  var updateDate = '更新日期';

  // 其他（变量名与文字不对等，需要先确认内容）
  var hasNewVersionHint = '發現新版本，是否升級？';
  var colorTextPlaceholder = '顏色|文字';
  var loadArticleErrToUseCache = '載入文章失敗，載入快取';
  var loadArticleErr = '載入文章失敗';
  var specialLinkUnsupported = '暫未適配特殊連結';
  var gettingImageUrl = '獲取圖片連結中...';
  var pageNameMissing = '該條目還未建立';
  var insufficientPermissions = '沒有許可權編輯該頁面';
  var loadErrToClickRetry = '載入失敗，點選重試';
  var doubleBackToExit = '再次按下退出程式';
  var articleMissedHint = '該頁面還未建立';
  var netErrToRetry = '網路錯誤，請重試';
  var pageVersionHistory = '頁面版本歷史';
  var categoryNameMappedPage = '這個分類對應的條目為';
  var emptyInCurrentCategory = '該分類下暫無條目';
  var noSummaryOnCurrentEdit = '該編輯未填寫摘要';
  var welcomeUser = (String userName) => '歡迎你，$userName';
  var loginOrJoinMoegirl = '登入/加入萌娘百科';
  var toggleNightMode = (bool isNight) => (isNight ? '關閉' : '開啟') + '黑夜模式';
  var noSpecifiedSection = '未指定章節';
  var inputUndoReasonPlease = '請輸入撤銷原因';
  var inputSummaryPlease = '請輸入摘要';
  var imageSavedToAlbum = '圖片已儲存至相簿';
  var markAllAsReaded = '標記所有為已讀';
  var toggleRecentChangesMode = (bool isWatchListMode) => '切換為${isWatchListMode ? '監視列表' : '全部列表'}模式';
  var toggleRecentChangeDetail = (bool visibleEditDetails, int totalNumberOfEdit) => (visibleEditDetails ? '收起' : '展開') + '詳細記錄(共$totalNumberOfEdit次編輯)';
  var searchResultTotal = (int resultTotal) => '共搜尋到$resultTotal條結果。';
  var searchResultRedirectTitle = (String title) => '「$title」指向該頁面';
  var searchResultSectionTitle = (String title) => '該頁面有名為“$title”的章節';
  var searchResultFromPageCategories = '匹配自頁面分類';
  var pageNoContent = '頁面內貌似沒有內容呢...';

  // 长提示（基本上只会在一个地方使用）
  var nonAutoConfirmedHint = '您不是自動確認使用者(編輯數超過10次且註冊超過24小時)，無法在客戶端進行編輯。要前往網頁版進行編輯嗎？';
  var notLoggedInHint = '未登入無法進行編輯，要前往登入介面嗎？';
  var historyModeEditDisabledHint = '你正在瀏覽歷史版本，編輯被禁用';
  var watchListOperatedHint = (bool isWatched) => '已${isWatched ? '移出' : '加入'}監視列表';
  var watchListOperateHint = (bool isExistsInWatchList) =>  '${isExistsInWatchList ? '移出' : '加入'}監視列表';
  var talkPageMissedHint = '該頁面討論頁未建立，是否要前往新增討論話題？';
  var bigPageSizeHint = '您搜尋的分類下頁面過多，搜尋時間可能會較長';
  var categoryDuplicateAddHint = '請勿重複新增分類';
  var commentLoginHint = '未登入無法進行評論，是否前往登入？';
  var delCommentHint = (bool isReply) => '確定要刪除自己的這條${isReply ? '回覆' : '評論'}嗎？';
  var reportHint = (bool isReply) => '確定要舉報這條${isReply ? '回覆' : '評論'}嗎？';
  var reoprtedHint = '已舉報，感謝您的反饋';
  var likeLoginHint = '未登入無法進行點贊，是否前往登入？';
  var replyLoginHint = '未登入無法進行回覆，是否前往登入？';
  var commentLeaveHint = '評論的內容不會儲存，確認要關閉嗎？';
  var emptySectionHint = '請在頂部新增一個標題';
  var emptyContentHint = '內容不能為空';
  var editconflictHint = '出現編輯衝突，請複製編輯的內容後再次進入編輯介面，並檢查差異';
  var protectedPageHint = '沒有許可權編輯此頁面';
  var databaseReadonlyHint = '目前資料庫處於鎖定狀態，無法編輯';
  var editleaveHint = '確定要退出編輯頁面嗎？您的編輯不會被儲存。';
  var cleanBbrowseHistoryHint = '確定要清空歷史記錄嗎？';
  var imageSavePermissionErrHint = '您未授予儲存許可權，圖片無法儲存';
  var userNameEmptyHint = '使用者名稱不能為空';
  var passwordEmptyHint = '密碼不能為空';
  var noAccountHint = '還沒有萌百帳號？點選前往官網註冊';
  var delSingleSearchRecordHint = '確定要刪除這條搜尋記錄嗎？';
  var delAllSearchRecordHint = '確定要刪除全部搜尋記錄嗎？';
  var cleanAllArticleCacheHint = '確定要清除全部條目快取嗎？';
  var cleanedAllArticleCacheHint = '已清除全部快取';
  var cleanAllBrowseHistoryHint = '確定要清除全部瀏覽歷史嗎？';
  var cleanedAllBrowseHistoryHint = '已清除全部瀏覽歷史';
  var logoutHint = '確定要登出嗎？';
  var heimuSwitchHelpText = '關閉後黑幕將預設為刮開狀態';
  var stopAudioOnLeave = '停止舊頁面背景媒體';
  var stopAudioOnLeaveHelpText = '開啟新條目時停止上一個條目中正在播放的音訊和影片';
  var cachePriorityModeHelpText = '如果有條目有快取將優先使用';
  var changingLanguageRestartHint = '修改語言重啟後生效';
  var emptySearchKeywordHint = '搜尋關鍵詞不能為空';

  // 特殊
  var moreMenuEditButton = (String status) => {
    'permissionsChecking': '檢查許可權中',
    'addTheme': '新增話題',
    'full': '編輯此頁',
    'disabled': '無權編輯此頁'
  }[status];
  var comparesummaryPrefix = (String userName, String toRevId) => '撤銷[[Special:Contributions/$userName|$userName]]（[[User_talk:$userName|討論]]）的版本$toRevId';
  var quickSummaryList = ['進行破壞', '新增不實內容', '內容過於主觀', '新增廣告', '排版發生錯亂'];
  var operationHelpContent = [
    '1. 左滑開啟抽屜',
    '2. 條目頁右滑開啟目錄',
    // '3. 條目內容中長按b站播放器按鈕跳轉至b站對應影片頁(當然前提是手機裡有b站app)',
    // '4. 左右滑動影片播放器小窗可以關閉影片'
  ].join('\n');
  var quickSummaryListOfEdit = ['修飾語句', '修正筆誤', '內容擴充', '排版'];
  var moegirlSloganText = '萌娘百科，萬物皆可萌的百科全書！';
  var chineseWeeks = ['', '一', '二', '三', '四', '五', '六', '日'];
  var yearMonthDateWeek = (int year, int month, int day, String week) => '$year年$month月$day日（星期$week）';
  var pageLastUpdateDate = ['最後更新於：', yyyy, '年', mm, '月', dd, '日'];
}