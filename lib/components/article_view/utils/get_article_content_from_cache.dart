import 'package:moegirl_viewer/api/article.dart';

final Map<String, dynamic> _articleCaches = {};

Future getArticleContentFromRamCache(String pageName, [bool forceLoad = false]) {
  return Future(() async {
    if (_articleCaches[pageName] == null || forceLoad) {
      _articleCaches[pageName] = await ArticleApi.articleDetail(pageName);
    }

    return _articleCaches[pageName];
  });
}