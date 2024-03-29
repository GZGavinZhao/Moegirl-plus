// @dart=2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/themes.dart';

Future<String> showDataSourceSelectionDialog({
  @required BuildContext context,
  @required String initialValue,
}) {
  final completer = Completer<String>();

  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (context) {
      return _LanguageSelectionDialog(
        initialValue: initialValue,
        completer: completer,
      );
    }
  )
    .then((value) {
      if (!completer.isCompleted) completer.complete(initialValue);
    });

  return completer.future;
}

class _LanguageSelectionDialog extends StatefulWidget {
  final String initialValue;
  final Completer completer;
  
  _LanguageSelectionDialog({
    @required this.initialValue,
    @required this.completer,
    Key key
  }) : super(key: key);

  @override
  _LanguageSelectionDialogState createState() => _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<_LanguageSelectionDialog> {
  String selected = '';
  final themesData = themes.keys
    .map((item) => _ThemeSelectionItem(item, themes[item].primaryColor));
  
  @override
  void initState() { 
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(Lang.dataSource,
        style: TextStyle(fontSize: 18),
      ),
      backgroundColor: theme.colorScheme.surface,
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            RadioListTile<String>(
              title: Text(Lang.siteName),
              value: 'moegirl',
              groupValue: selected,
              onChanged: (value) => setState(() => selected = value),
            ),
            RadioListTile<String>(
              title: Text(Lang.siteName_h),
              value: 'hmoe',
              groupValue: selected,
              onChanged: (value) => setState(() => selected = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(theme.splashColor),
            foregroundColor: MaterialStateProperty.all(theme.hintColor)
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.completer.complete(widget.initialValue);
          },
          child: Text(Lang.close),
        ), 
        TextButton(
          child: Text(Lang.check),
          onPressed: () {
            Navigator.of(context).pop();
            widget.completer.complete(selected);
          },
        ),
      ],
    );
  }
}

class _ThemeSelectionItem {
  final String name;
  final Color color;

  _ThemeSelectionItem(this.name, this.color);
}

