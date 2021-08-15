import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/provider_selectors/night_selector.dart';
import 'package:moegirl_plus/components/styled_widgets/scrollbar.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/components/user_tail.dart';
import 'package:moegirl_plus/constants.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/compare/utils/collect_diff_blocks_from_html.dart';
import 'package:one_context/one_context.dart';

class CompareDiffContent extends StatefulWidget {
  final List<DiffLine> diffLines;
  final String userName;
  final String comment;
  final bool pureTextMode;
  
  CompareDiffContent({
    @required this.diffLines,
    @required this.userName,
    @required this.comment,
    @required this.pureTextMode,
    Key key
  }) : super(key: key);

  @override
  _CompareDiffContentState createState() => _CompareDiffContentState();
}

class _CompareDiffContentState extends State<CompareDiffContent> with AutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;
  
  static final borderColors = {
    'normal': {
      DiffRowMarker.none: Color(0xffe6e6e6),
      DiffRowMarker.plus: Color(0xffd8ecff),
      DiffRowMarker.minus: Color(0xffffe49c)
    },

    'night': {
      DiffRowMarker.none: Color(0xff6D6D6D),
      DiffRowMarker.plus: Color(0xff81DAF5),
      DiffRowMarker.minus: Color(0xffFFCC00)
    }
  };
  
  static final contentColors = {
    'normal': {
      DiffRowContentType.plain: Colors.transparent,
      DiffRowContentType.add: Color(0xffd8ecff),
      DiffRowContentType.delete: Color(0xffffe49c),
    },

    'night': {
      DiffRowContentType.plain: Colors.transparent,
      DiffRowContentType.add: Color(0xff81DAF5).withOpacity(0.3),
      DiffRowContentType.delete: Color(0xffFFCC00).withOpacity(0.3),
    }
  };

  final List<List<GlobalKey>> lineGlobalKeys = [];
  final List<List<double>> lineRowsSyncHeights = [];

  @override
  void initState() { 
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5).copyWith(top: 3),
      child: StyledScrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!widget.pureTextMode) (
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TouchableOpacity(
                            onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: 'User:${widget.userName}')),
                            child: Container(
                              width: 30,       
                              height: 30,
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                image: DecorationImage(
                                  image: NetworkImage((RuntimeConstants.source == 'moegirl' ? avatarUrl : hmoeAvatarUrl) + widget.userName)
                                )
                              ),
                            ),
                          ),

                          TouchableOpacity(
                            onPressed: () => OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(pageName: 'User:${widget.userName}')),
                            child: Text(widget.userName,
                              style: TextStyle(
                                color: theme.accentColor,
                                fontSize: 14,
                                height: 1
                              ),
                            )
                          ),

                          UserTail(userName: widget.userName)
                        ],
                      ),

                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        child: widget.comment == '' ? 
                          Text('（${Lang.noSummary}）', style: TextStyle(color: theme.disabledColor)) :
                          Text('${Lang.summary}：${widget.comment}')
                      )
                    ],
                  ),
                )
              ),

              Container(
                child: Column(
                  children: widget.diffLines.asMap().map((lineIndex, line) =>
                    MapEntry(lineIndex, 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(line.lineHint,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),

                          Container(
                            height: 3,
                            color: theme.accentColor,
                            margin: EdgeInsets.only(right: 10, bottom: 10),
                          ),

                          ...line.rows.asMap().map((rowIndex, row) =>
                            MapEntry(rowIndex,
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: row.marker != DiffRowMarker.none ? 
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3),
                                        child: Icon(row.marker == DiffRowMarker.plus ? Icons.add : Icons.remove, 
                                          size: 20,
                                          color: theme.disabledColor,
                                        ),
                                      )
                                    :
                                      Container(width: 20)
                                    ,
                                  ),
                                  
                                  NightSelector(
                                    builder: (isNight) => (
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          padding: EdgeInsets.only(left: 5, top: 3, bottom: 3),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(color: borderColors[isNight ? 'night' : 'normal'][row.marker], width: 5)
                                            ),
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: theme.textTheme.bodyText1.color,
                                              ),
                                              children: row.content.map((item) => 
                                                TextSpan(
                                                  text: item.text,
                                                  style: TextStyle(
                                                    backgroundColor: contentColors[isNight ? 'night' : 'normal'][item.type],
                                                  )
                                                )
                                              ).toList()
                                            ),
                                          )
                                        )
                                      )
                                    ),
                                  )
                                ],
                              )
                            )
                          ).values.toList()
                        ],
                      )
                    )
                  ).values.toList(),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}