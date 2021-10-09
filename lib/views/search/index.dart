// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/app_bar_back_button.dart';
import 'package:moegirl_plus/utils/setRootBrightness.dart';
import 'package:moegirl_plus/views/search/components/app_bar_body.dart';
import 'package:moegirl_plus/views/search/components/recent_search.dart';

import 'components/search_hint.dart';

class SearchPageRouteArgs {
  final String keyword;
  
  SearchPageRouteArgs({
    @required this.keyword
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
  void initState() { 
    super.initState();
    setRootBrightness(Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);    
    return NightSelector(
      builder: (isNight) => (
        Scaffold(
          appBar: AppBar(
            systemOverlayStyle: isNight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
            backgroundColor: isNight ? theme.primaryColor : Colors.white,
            elevation: 3,
            leading: AppBarBackButton(
              color: isNight ? theme.colorScheme.onPrimary : theme.hintColor,
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
        )
      )
    );
  }
}