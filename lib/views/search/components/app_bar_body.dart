import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPageAppBarBody extends StatefulWidget {
  final void Function(String) onChanged;

  SearchPageAppBarBody({
    Key key,
    this.onChanged
  }) : super(key: key);

  @override
  _SearchPageAppBarBodyState createState() => _SearchPageAppBarBodyState();
}

class _SearchPageAppBarBodyState extends State<SearchPageAppBarBody> {
  final editingController = TextEditingController();

  
  @override
  void initState() { 
    super.initState();
    editingController.addListener(() => setState(() {}));
  }

  void clearInputText() {
    editingController.clear();
    widget.onChanged('');
  }

  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            cursorHeight: 22,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              border: InputBorder.none
            ),
            style: TextStyle(
              fontSize: 18
            ),
            controller: editingController,
            onChanged: widget.onChanged,
          ),
        ),

        if (editingController.text != '') (
          CupertinoButton(
            onPressed: clearInputText,
            child: Icon(Icons.close,
              size: 20,
              color: Colors.grey,
            ),
          )
        )
      ],
    );
  }
}