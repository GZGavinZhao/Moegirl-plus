import 'package:flutter/material.dart';
import 'package:moegirl_viewer/prefs/index.dart';
import 'package:moegirl_viewer/prefs/search.dart';

class SearchPageRecentSearch extends StatefulWidget {
  SearchPageRecentSearch({Key key}) : super(key: key);

  @override
  _SearchPageRecentSearchState createState() => _SearchPageRecentSearchState();
}

class _SearchPageRecentSearchState extends State<SearchPageRecentSearch> {
  final searchingHistoryList = searchingHistoryPref.getList();

  
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}