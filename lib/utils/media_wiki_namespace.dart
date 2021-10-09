// @dart=2.9
enum MediaWikiNamespace {
  // 内建命名空间
  main, mainTalk,
  user, userTalk, 
  project, projectTalk, 
  file, fileTalk,
  mediaWiki, mediaWikiTalk,
  template, templateTalk,
  help, helpTalk,
  category, categoryTalk,

  // 扩展命名空间
  widget, widgetTalk,
  timedText, timedTextTalk,
  module, moduleTalk,

  special, media,
}

const _mediaWikiNamespaceCodeMaps = {
  0: MediaWikiNamespace.main,
  1: MediaWikiNamespace.mainTalk,
  2: MediaWikiNamespace.user,
  3: MediaWikiNamespace.userTalk,
  4: MediaWikiNamespace.project,
  5: MediaWikiNamespace.projectTalk,
  6: MediaWikiNamespace.file,
  7: MediaWikiNamespace.fileTalk,
  8: MediaWikiNamespace.mediaWiki,
  9: MediaWikiNamespace.mediaWikiTalk,
  10: MediaWikiNamespace.template,
  11: MediaWikiNamespace.templateTalk,
  12: MediaWikiNamespace.help,
  13: MediaWikiNamespace.helpTalk,
  14: MediaWikiNamespace.category,
  15: MediaWikiNamespace.categoryTalk,

  274: MediaWikiNamespace.widget,
  275: MediaWikiNamespace.widgetTalk,
  710: MediaWikiNamespace.timedText,
  172: MediaWikiNamespace.timedTextTalk,
  828: MediaWikiNamespace.module,
  829: MediaWikiNamespace.moduleTalk
};

bool isTalkPage(int ns) {
  final nsType = _mediaWikiNamespaceCodeMaps[ns];
  if (nsType == null) return false;
  return nsType.toString().contains('Talk');
}

MediaWikiNamespace getPageNamespace(int ns) => _mediaWikiNamespaceCodeMaps[ns];
int getNsCode(MediaWikiNamespace mediaWikiNamespace) => 
  _mediaWikiNamespaceCodeMaps.keys.singleWhere((key) => _mediaWikiNamespaceCodeMaps[key] == mediaWikiNamespace, orElse: () => null);