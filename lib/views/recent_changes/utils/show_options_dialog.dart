import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/capsule_checkbox.dart';
import 'package:moegirl_plus/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_plus/language/index.dart';

Future<RecentChangesOptions> showRecentChangesOptionsDialog(
  BuildContext context, 
  RecentChangesOptions initialValue
) {
  final completer = Completer<RecentChangesOptions>();
  
  showDialog(
    context: context,
    useRootNavigator: false,
    builder: (context) => _OptionsDialog(
      initialValue: initialValue,
      completer: completer,
    )
  );

  return completer.future;
}

class _OptionsDialog extends StatefulWidget {
  final RecentChangesOptions initialValue;
  final Completer<RecentChangesOptions> completer;
  
  _OptionsDialog({
    this.initialValue,
    this.completer,
    Key key
  }) : super(key: key);

  @override
  _OptionsDialogState createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<_OptionsDialog> {
  RecentChangesOptions options;

  @override
  void initState() { 
    super.initState();
    options = widget.initialValue.copyWith();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(Lang.listOptions),
      backgroundColor: theme.colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 16
                  ),
                  children: [
                    TextSpan(text: '${Lang.timeRange}：'),
                    TextSpan(
                      text: options.daysAgo.toString(),
                      style: TextStyle(
                        color: theme.accentColor, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(text: Lang.withinDay),
                  ]
                ),
              ),
              Slider(
                activeColor: theme.accentColor,
                inactiveColor: theme.accentColor.withOpacity(0.2),
                value: options.daysAgo.toDouble(),
                min: 1,
                max: 7,
                divisions: 7,
                onChanged: (value) => setState(() => options = options.copyWith(daysAgo: value.toInt())),
              ),

              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 16
                  ),
                  children: [
                    TextSpan(text: '${Lang.maxShownNumber}：'),
                    TextSpan(
                      text: options.totalLimit.toString(),
                      style: TextStyle(
                        color: theme.accentColor, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(text: Lang.number),
                  ]
                ),
              ),
              Slider(
                activeColor: theme.accentColor,
                inactiveColor: theme.accentColor.withOpacity(0.2),
                value: options.totalLimit.toDouble(),
                min: 50,
                max: 500,
                divisions: 5,
                onChanged: (newVal) => setState(() => options = options.copyWith(totalLimit: newVal.toInt())),
              ),

              Text(Lang.changeType,
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 16
                ),
              ),
              Container(height: 5),
              LoggedInSelector(
                builder: (isLoggedIn) => (
                  Container(
                    child: Wrap(
                      children: [
                        if (isLoggedIn) (
                          Padding(
                            padding: EdgeInsets.only(right: 5, bottom: 5),
                            child: CapsuleCheckbox(
                              title: Lang.myEdit,
                              value: options.includeSelf,
                              onPressed: (newVal) => setState(() => options = options.copyWith(includeSelf: newVal))
                            ),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: CapsuleCheckbox(
                            title: Lang.robot,
                            value: options.includeRobot,
                            onPressed: (newVal) => setState(() => options = options.copyWith(includeRobot: newVal))
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: CapsuleCheckbox(
                            title: Lang.microEdit,
                            value: options.includeMinor,
                            onPressed: (newVal) => setState(() => options = options.copyWith(includeMinor: newVal))
                          ),
                        ),
                      ],
                    ),
                  )
                ),  
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(Lang.check),
          onPressed: () {
            Navigator.of(context).pop();
            widget.completer.complete(options);
          },
        ),
      ],
    );
  }
}

class RecentChangesOptions {
  final int daysAgo;
  final int totalLimit;
  final bool includeSelf;
  final bool includeRobot;
  final bool includeMinor;
  final bool isWatchListMode;

  RecentChangesOptions({
    this.daysAgo = 7,
    this.totalLimit = 500,
    this.includeSelf = true,
    this.includeMinor = true,
    this.includeRobot = false,
    this.isWatchListMode = false,
  });

    
  RecentChangesOptions.fromMap(Map<String, dynamic> map) :
    daysAgo = map['daysAgo'],
    totalLimit = map['totalLimit'],
    includeSelf = map['includeSelf'],
    includeRobot = map['includeRobot'],
    includeMinor = map['includeMinor'],
    isWatchListMode = map['isWatchListMode']
  ;

  Map<String, dynamic> toMap() {
    return {
      'daysAgo': daysAgo,
      'totalLimit': totalLimit,
      'includeSelf': includeSelf,
      'includeRobot': includeRobot,
      'includeMinor': includeMinor,
      'isWatchListMode': isWatchListMode
    };
  }

  RecentChangesOptions copyWith({
    int daysAgo,
    int totalLimit,
    bool includeSelf,
    bool includeRobot,
    bool includeMinor,
    bool isWatchListMode,
  }) {
    return RecentChangesOptions(
      daysAgo: daysAgo ?? this.daysAgo,
      totalLimit: totalLimit ?? this.totalLimit,
      includeSelf: includeSelf ?? this.includeSelf,
      includeRobot: includeRobot ?? this.includeRobot,
      includeMinor: includeMinor ?? this.includeMinor,
      isWatchListMode: isWatchListMode ?? this.isWatchListMode
    );
  }
}