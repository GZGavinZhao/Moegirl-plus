import 'package:flutter/material.dart';
import 'package:moegirl_plus/language/index.dart';

class ArticlePageFindBar extends StatefulWidget {
  final bool visible;
  final void Function(String) onFindAll;
  final void Function() onFindNext;
  final void Function() onClosed;
  
  ArticlePageFindBar({
    @required this.visible,
    @required this.onFindAll,
    @required this.onFindNext,
    @required this.onClosed,
    Key key,
  }) : super(key: key);

  @override
  _ArticlePageFindBarState createState() => _ArticlePageFindBarState();
}

class _ArticlePageFindBarState extends State<ArticlePageFindBar> {
  final editingController = TextEditingController();
  
  @override
  void didUpdateWidget (ArticlePageFindBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 关闭搜索栏时清空输入框，隐藏输入法
    if (oldWidget.visible && !widget.visible) {
      editingController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return IgnorePointer(
      ignoring: !widget.visible,
      child: AnimatedOpacity(
        opacity: widget.visible ? 1 : 0, 
        duration: Duration(milliseconds: 150),
        child: Container(
          height: 40,
          width: 270,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            boxShadow: [BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              offset: Offset(0, 1),
              blurRadius: 2,
            )]
          ),
          child: Row(
            children: [
              Material(
                type: MaterialType.transparency,
                child: IconButton(
                  icon: Icon(Icons.close,
                    size: 14,
                  ),
                  splashRadius: 13,
                  splashColor: theme.colorScheme.secondary.withOpacity(0.2),
                  highlightColor: theme.colorScheme.secondary.withOpacity(0.2),
                  onPressed: widget.onClosed, 
                ),
              ),
              
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: TextField( 
                    controller: editingController,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 14
                    ),
                    onChanged: widget.onFindAll,
                    onSubmitted: (_) => widget.onFindNext(),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(right: 2),
                child: TextButton(
                  onPressed: widget.onFindNext, 
                  child: Text(Lang.findNext,
                    style: TextStyle(fontSize: 13),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}