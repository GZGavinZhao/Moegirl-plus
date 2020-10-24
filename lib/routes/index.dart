import 'package:fluro/fluro.dart';
import 'package:moegirl_viewer/views/article/index.dart';
import 'package:moegirl_viewer/views/history/index.dart';
import 'package:moegirl_viewer/views/image_previewer/index.dart';
import 'package:moegirl_viewer/views/index/index.dart';
import 'package:moegirl_viewer/views/login/index.dart';
import 'package:moegirl_viewer/views/search/index.dart';
import 'package:moegirl_viewer/views/search/views/result/index.dart';
import 'package:moegirl_viewer/views/settings/index.dart';

import 'router.dart';

final routes = {
  '/': Route((r) => IndexPage(r)),
  '/article': Route((r) => ArticlePage(r)),
  '/search': Route((r) => SearchPage(r), TransitionType.material),
  '/search/result': Route((r) => SearchResultPage(r)),
  '/imagePreviewer': Route((r) => ImagePreviewerPage(r), TransitionType.fadeIn),
  '/login': Route((r) => LoginPage(r)),
  '/history': Route((r) => HistoryPage(r)),
  '/settings': Route((r) => SettingsPage(r))
};

// class AppModule extends MainModule {
//   final Widget Function() appWidgetBuilder;
//   AppModule(this.appWidgetBuilder);

//   @override
//   List<Bind> get binds => [];

//   @override
//   List<ModularRouter> get routers => [
//     _route('/', (_, __) => IndexPage(IndexPageRouteArgs())),
//     _route('/search', (_, __) => SearchPage(SearchPageRouteArgs()))
//   ];

//   @override
//   Widget get bootstrap => appWidgetBuilder();
// }

// ModularRouter _route(
//   String routeName, 
//   Widget Function(BuildContext, ModularArguments) child,
//   // [TransitionType transitionType = TransitionType.rotate]
// ) {
//   return ModularRouter(
//     routeName, 
//     child: child, 
//     transition: TransitionType.,
//     customTransition: myCustomTransition
//   );
// }

// CustomTransition get myCustomTransition => CustomTransition(
//     transitionDuration: Duration(milliseconds: 500),
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       CupertinoPageRoute
//       return CupertinoPageTransition(
//         primaryRouteAnimation: animation,
//         secondaryRouteAnimation: secondaryAnimation,
//         child: child,
//         linearTransition: false
//       );
//     },
//   );