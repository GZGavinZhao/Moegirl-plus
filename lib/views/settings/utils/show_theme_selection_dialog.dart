
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/components/provider_selectors/night_selector.dart';
import 'package:moegirl_viewer/providers/settings.dart';
import 'package:moegirl_viewer/themes.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

Future<String> showThemeSelectionDialog({
  @required String initialValue,
  @required void Function(String themeName) onChange,
}) {
  final completer = Completer<String>();

  OneContext().showDialog(
    barrierDismissible: false,
    builder: (context) {
      return SettingsPageThemeSelectionDialog(
        initialValue: initialValue,
        completer: completer,
        onChange: onChange,
      );
    }
  )
    .then((value) {
      if (!completer.isCompleted) completer.complete(initialValue);
    });

  return completer.future;
}

class SettingsPageThemeSelectionDialog extends StatefulWidget {
  final String initialValue;
  final Completer completer;
  final void Function(String themeName) onChange;
  
  SettingsPageThemeSelectionDialog({
    @required this.initialValue,
    @required this.completer,
    @required this.onChange,
    Key key
  }) : super(key: key);

  @override
  _SettingsPageThemeSelectionDialogState createState() => _SettingsPageThemeSelectionDialogState();
}

class _SettingsPageThemeSelectionDialogState extends State<SettingsPageThemeSelectionDialog> {
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
      title: Text('选择主题'),
      backgroundColor: theme.colorScheme.surface,
      content: SingleChildScrollView(
        child: NightSelector(
          builder: (isNight) => (
            Wrap(
              alignment: WrapAlignment.center,
              children: themesData.map((item) =>
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: isNight ? Border.all(width: 3, color: theme.disabledColor) : null
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.5),
                      highlightColor: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                      onTap: () => setState(() {
                        selected = item.name;
                        widget.onChange(item.name);
                      }),
                      child:selected == item.name ?
                        SizedBox.expand(
                          child: Icon(Icons.check, 
                            color: Colors.white,
                            size: 25,
                          ),
                        )
                      : null,
                    ),
                  ),
                )
              ).toList(),
            )
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
            widget.completer.complete(selected);
          },
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(theme.splashColor),
            foregroundColor: MaterialStateProperty.all(theme.hintColor)
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.completer.complete(widget.initialValue);
          },
          child: Text('取消'),
        ) 
      ],
    );
  }
}

class _ThemeSelectionItem {
  final String name;
  final Color color;

  _ThemeSelectionItem(this.name, this.color);
}

