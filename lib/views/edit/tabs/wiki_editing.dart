import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/indexed_view.dart';
import 'package:moegirl_plus/components/styled_widgets/circular_progress_indicator.dart';
import 'package:moegirl_plus/components/wiki_editor2/index.dart';
import 'package:moegirl_plus/language/index.dart';

class EditPageWikiEditing extends StatefulWidget {
  final String value;
  final int status;
  final FocusNode focusNode;
  final bool quickInsertBarEnabled;
  final bool newSection;
  final void Function(String text) onContentChanged;
  final void Function() onReloadButtonPressed;
  
  EditPageWikiEditing({
    @required this.value,
    @required this.status,
    @required this.focusNode,
    this.quickInsertBarEnabled = true,
    this.newSection = false,
    @required this.onContentChanged,
    @required this.onReloadButtonPressed,
    Key key
  }) : super(key: key);

  @override
  _EditPageWikiEditingState createState() => _EditPageWikiEditingState();
}

class _EditPageWikiEditingState extends State<EditPageWikiEditing> with AutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Container(
      alignment: Alignment.center,
      child: IndexedView(
        index: widget.status,
        builders: {
          0: () => TextButton(
            child: Text(l.editPage_wikiEidting_reload,
              style: TextStyle(
                fontSize: 16
              ),
            ),
            onPressed: widget.onReloadButtonPressed,
          ),

          2: () => StyledCircularProgressIndicator(),

          3: () => WikiEditor2(
            focusNode: widget.focusNode,
            quickInsertBarEnabled: widget.quickInsertBarEnabled,
            initialValue: widget.value,
            newSection: widget.newSection,
            onChanged: widget.onContentChanged,
          )
        },
      )
    );
  }
}