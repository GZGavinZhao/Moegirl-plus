// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `萌娘百科`
  String get siteName {
    return Intl.message(
      '萌娘百科',
      name: 'siteName',
      desc: '',
      args: [],
    );
  }

  /// `讨论`
  String get talkPagePrefix {
    return Intl.message(
      '讨论',
      name: 'talkPagePrefix',
      desc: '',
      args: [],
    );
  }

  /// `再次按下退出程序`
  String get indexPage_backHint {
    return Intl.message(
      '再次按下退出程序',
      name: 'indexPage_backHint',
      desc: '',
      args: [],
    );
  }

  /// `你正在浏览历史版本，编辑被禁用`
  String get articlePage_historyModeEditDisabledHint {
    return Intl.message(
      '你正在浏览历史版本，编辑被禁用',
      name: 'articlePage_historyModeEditDisabledHint',
      desc: '',
      args: [],
    );
  }

  /// `该页面还未创建`
  String get articlePage_articleMissedHint {
    return Intl.message(
      '该页面还未创建',
      name: 'articlePage_articleMissedHint',
      desc: '',
      args: [],
    );
  }

  /// `{isWatched, select, true {已移出监视列表} false {已加入监视列表} }`
  String articlePage_watchListOperatedHint(Object isWatched) {
    return Intl.select(
      isWatched,
      {
        'true': '已移出监视列表',
        'false': '已加入监视列表',
      },
      name: 'articlePage_watchListOperatedHint',
      desc: '',
      args: [isWatched],
    );
  }

  /// `该页面讨论页未创建，是否要前往添加讨论话题？`
  String get articlePage_talkPageMissedHint {
    return Intl.message(
      '该页面讨论页未创建，是否要前往添加讨论话题？',
      name: 'articlePage_talkPageMissedHint',
      desc: '',
      args: [],
    );
  }

  /// `萌娘百科分享`
  String get articlePage_shareSuffix {
    return Intl.message(
      '萌娘百科分享',
      name: 'articlePage_shareSuffix',
      desc: '',
      args: [],
    );
  }

  /// `加载中`
  String get articlePage_commentButtonLoadingHint {
    return Intl.message(
      '加载中',
      name: 'articlePage_commentButtonLoadingHint',
      desc: '',
      args: [],
    );
  }

  /// `更多选项`
  String get articlePage_header_moreButtonTooltip {
    return Intl.message(
      '更多选项',
      name: 'articlePage_header_moreButtonTooltip',
      desc: '',
      args: [],
    );
  }

  /// `刷新`
  String get articlePage_header_moreMenuRefreshButton {
    return Intl.message(
      '刷新',
      name: 'articlePage_header_moreMenuRefreshButton',
      desc: '',
      args: [],
    );
  }

  /// `{status, select, permissionsChecking {检查权限中} addTheme {添加话题} full {编辑此页} disabled {无权编辑此页}}`
  String articlePage_header_moreMenuEditButton(Object status) {
    return Intl.select(
      status,
      {
        'permissionsChecking': '检查权限中',
        'addTheme': '添加话题',
        'full': '编辑此页',
        'disabled': '无权编辑此页',
      },
      name: 'articlePage_header_moreMenuEditButton',
      desc: '',
      args: [status],
    );
  }

  /// `登录`
  String get articlePage_header_moreMenuLoginButton {
    return Intl.message(
      '登录',
      name: 'articlePage_header_moreMenuLoginButton',
      desc: '',
      args: [],
    );
  }

  /// `{isExistsInWatchList, select, true {移出监视列表} false{加入监视列表} }`
  String articlePage_header_moreMenuWatchListButton(Object isExistsInWatchList) {
    return Intl.select(
      isExistsInWatchList,
      {
        'true': '移出监视列表',
        'false': '加入监视列表',
      },
      name: 'articlePage_header_moreMenuWatchListButton',
      desc: '',
      args: [isExistsInWatchList],
    );
  }

  /// `前往讨论页`
  String get articlePage_header_moreMenuGotoTalkPageButton {
    return Intl.message(
      '前往讨论页',
      name: 'articlePage_header_moreMenuGotoTalkPageButton',
      desc: '',
      args: [],
    );
  }

  /// `前往版本历史`
  String get articlePage_header_moreMenuGotoVersionHistoryButton {
    return Intl.message(
      '前往版本历史',
      name: 'articlePage_header_moreMenuGotoVersionHistoryButton',
      desc: '',
      args: [],
    );
  }

  /// `分享`
  String get articlePage_header_moreMenuGotoShareButton {
    return Intl.message(
      '分享',
      name: 'articlePage_header_moreMenuGotoShareButton',
      desc: '',
      args: [],
    );
  }

  /// `打开目录`
  String get articlePage_header_moreMenuShowContentsButton {
    return Intl.message(
      '打开目录',
      name: 'articlePage_header_moreMenuShowContentsButton',
      desc: '',
      args: [],
    );
  }

  /// `目录`
  String get articlePage_contents_title {
    return Intl.message(
      '目录',
      name: 'articlePage_contents_title',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get settingsPage_title {
    return Intl.message(
      '设置',
      name: 'settingsPage_title',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}