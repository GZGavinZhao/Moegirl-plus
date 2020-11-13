import 'dart:convert';
import 'dart:io';
import 'package:moegirl_viewer/utils/compute_md5.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cacheDirName = 'artcile_cache';
const _redirectMapListFileName = 'article_redirect.json';

class ArticleCacheManager {  
  static Future<File> addCache(String pageName, ArticleCache articleCache) async {
    final filePath = await _getCachePath(pageName);
    final file = await File(filePath).create(recursive: true);
    return file.writeAsString(articleCache.toJson());
  }

  static Future<ArticleCache> getCache(String pageName) async {
    final redirectList = _RedirectList();
    final truePageName = (await redirectList.getRedirectToName(pageName)) ?? pageName; 

    final filePath = await _getCachePath(truePageName);
    final stat = await FileStat.stat(filePath);
    if (stat.type != FileSystemEntityType.notFound) {
      return ArticleCache.fromJson(await File(filePath).readAsString());
    } else {
      print('$pageName：文章缓存不存在');
      return  null;
    }
  }

  static Future<void> clearCache() async {
    final dir = Directory(await _getCachePath());
    return dir.delete(recursive: true);
  }

  static Future<void> addRedirect(String redirectName, String redirectToName) async {
    final redirectList = _RedirectList();
    return redirectList.addRedirect(redirectName, redirectToName);
  }
}

Future<String> _getCachePath([String pageName]) async {
  final cachePath = (await getExternalCacheDirectories())[0].path;
  String fileName;
  if (pageName != null) {
    final pref = await SharedPreferences.getInstance();
    final source = pref.getString('source');
    final lang = pref.getString('lang');
    fileName = computeMd5([pageName, source, lang].join());
  }
  return p.join(cachePath, _cacheDirName, fileName ?? '');
}

class ArticleCache {
  Map articleData;
  Map pageInfo;

  ArticleCache({
    this.articleData,
    this.pageInfo
  });

  ArticleCache.fromJson(String json) {
    final map = jsonDecode(json);
    articleData = map['articleData'];
    pageInfo = map['pageInfo'];
  }

  String toJson() {
    return jsonEncode({
      'articleData': articleData,
      'pageInfo': pageInfo
    });
  }
}

class _RedirectList {
  Future<File> _fileFuture;
  Future<Map> redirectListFuture;
  static _RedirectList _instance;

  factory _RedirectList() {
    _instance ??= _RedirectList._internal();
    return _instance;
  }

  _RedirectList._internal() {
    _fileFuture = Future(() async {
      final appDocPath = (await getApplicationDocumentsDirectory()).path;
      final redirectFilePath = p.join(appDocPath, _redirectMapListFileName);
      final file = File(redirectFilePath);
      final stat = await FileStat.stat(redirectFilePath);
      if (stat.type != FileSystemEntityType.notFound) {
        return file;
      } else {
        return file.create(recursive: true);
      }
    });

    redirectListFuture = Future(() async {
      final file = await _fileFuture;
      final fileContent = await file.readAsString();
      return fileContent != '' ? jsonDecode(fileContent) : {};
    });
  }

  Future<void> addRedirect(String redirectName, String redirectToName) async {
    if (redirectName == redirectToName) return;
    final redirectList = await redirectListFuture;
    final file = await _fileFuture;
    redirectList[redirectName] = redirectToName;
    return file.writeAsString(jsonEncode(redirectList));
  }

  Future<String> getRedirectToName(String redirectName) async {
    final redirectList = await redirectListFuture;
    return redirectList[redirectName];
  }
}