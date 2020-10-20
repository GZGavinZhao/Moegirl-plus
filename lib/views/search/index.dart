import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_viewer/utils/route_aware.dart';
import 'package:moegirl_viewer/utils/ui/set_status_bar.dart';
import 'package:moegirl_viewer/views/search/components/app_bar_body.dart';
import 'package:moegirl_viewer/views/search/components/recent_search.dart';
import 'package:one_context/one_context.dart';

import 'components/search_hint.dart';

class SearchPageRouteArgs {
  final String keyword;
  
  SearchPageRouteArgs({
    this.keyword
  });
}

class SearchPage extends StatefulWidget {
  final SearchPageRouteArgs routeArgs;

  SearchPage(this.routeArgs, {Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 3,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff666666),
          iconSize: 26,
          splashRadius: 20,
          onPressed: () => OneContext().pop(),
        ),
        title: SearchPageAppBarBody(
          onChanged: (text) => setState(() => inputText = text),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: inputText == '' ? 
          SearchPageRecentSearch() :
          SrarchPageSearchHint(
            keyword: inputText,
          ),
      )
    );
  }
}