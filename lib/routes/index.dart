import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' hide Router, Route;
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/image_previewer/index.dart';
import 'package:moegirl_viewer/views/index/index.dart';
import 'package:moegirl_viewer/views/login/index.dart';
import 'package:moegirl_viewer/views/search/index.dart';

import 'router.dart';

final routes = {
  '/': Route((r) => IndexPage(r)),
  '/article': Route((r) => ArticlePage(r)),
  '/search': Route((r) => SearchPage(r), TransitionType.material),
  '/imagePreviewer': Route((r) => ImagePreviewerPage(r), TransitionType.fadeIn),
  '/login': Route((r) => LoginPage(r))
};