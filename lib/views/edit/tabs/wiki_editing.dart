import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/indexedView.dart';
import 'package:moegirl_viewer/components/styled_widgets/circular_progress_indicator.dart';

class EditPageWikiEditing extends StatefulWidget {
  final String value;
  final int status;
  final void Function(String text) onChanged;
  final void Function() onReloadButtonPressed;
  
  EditPageWikiEditing({
    @required this.value,
    @required this.status,
    @required this.onChanged,
    @required this.onReloadButtonPressed,
    Key key
  }) : super(key: key);

  @override
  _EditPageWikiEditingState createState() => _EditPageWikiEditingState();
}

class _EditPageWikiEditingState extends State<EditPageWikiEditing> with AutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;
  bool visibleQuickInsertBar = false;
  final textEditingController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    textEditingController.addListener(() {
      print(textEditingController.selection.start);
    });
  }

  @override
  void dispose(){
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.value;
    

    return Container(
      alignment: Alignment.center,
      child: IndexedView(
        index: widget.status,
        builders: {
          0: () => TextButton(
            child: Text('重新加载',
              style: TextStyle(
                fontSize: 16
              ),
            ),
            onPressed: widget.onReloadButtonPressed,
          ),

          2: () => StyledCircularProgressIndicator(),

          3: () => Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: textEditingController,
                      minLines: null,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                      ),
                    )
                  ),
                ),
              ),
              Offstage(
                offstage: !visibleQuickInsertBar,
                child: Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    child: Row(
                      children: [
                        
                      ],
                    ),
                  ),
                ),
              )
            ]
          )
        },
      )
    );
  }
}