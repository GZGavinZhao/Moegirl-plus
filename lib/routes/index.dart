import 'package:fluro/fluro.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/category/index.dart';
import 'package:moegirl_plus/views/category/views/search/index.dart';
import 'package:moegirl_plus/views/comment/index.dart';
import 'package:moegirl_plus/views/comment/views/reply/index.dart';
import 'package:moegirl_plus/views/compare/index.dart';
import 'package:moegirl_plus/views/edit/index.dart';
import 'package:moegirl_plus/views/edit_history/index.dart';
import 'package:moegirl_plus/views/history/index.dart';
import 'package:moegirl_plus/views/image_previewer/index.dart';
import 'package:moegirl_plus/views/index/index.dart';
import 'package:moegirl_plus/views/login/index.dart';
import 'package:moegirl_plus/views/notification/index.dart';
import 'package:moegirl_plus/views/recent_changes/index.dart';
import 'package:moegirl_plus/views/search/index.dart';
import 'package:moegirl_plus/views/search/views/result/index.dart';
import 'package:moegirl_plus/views/settings/index.dart';
import 'package:moegirl_plus/views/contribution/index.dart';
import 'package:moegirl_plus/views/captcha/index.dart';


import 'router.dart';

final routes = {
  '/': Route((r) => IndexPage(r)),
  '/article': Route((r) => ArticlePage(r)),
  '/search': Route((r) => SearchPage(r), TransitionType.material),
  '/search/result': Route((r) => SearchResultPage(r), TransitionType.material),
  '/imagePreviewer': Route((r) => ImagePreviewerPage(r), TransitionType.fadeIn),
  '/login': Route((r) => LoginPage(r)),
  '/history': Route((r) => HistoryPage(r)),
  '/settings': Route((r) => SettingsPage(r)),
  '/edit': Route((r) => EditPage(r)),
  '/comment': Route((r) => CommentPage(r)),
  '/comment/reply': Route((r) => CommentReplyPage(r), TransitionType.material),
  '/category': Route((r) => CategoryPage(r)),
  '/categorySearch': Route((r) => CategorySearchPage(r)),
  '/notification': Route((r) => NotificationPage(r)),
  '/recentChanges': Route((r) => RecentChangesPage(r)),
  '/compare': Route((r) => ComparePage(r)),
  '/editHistory': Route((r) => EditHistoryPage(r)),
  '/contribution': Route((r) => ContributionPage(r)),
  '/captcha': Route((r) => WebViewPage(r), TransitionType.none)
};