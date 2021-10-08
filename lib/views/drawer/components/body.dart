import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:moegirl_plus/components/provider_selectors/logged_in_selector.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/prefs/index.dart';
import 'package:moegirl_plus/providers/account.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:moegirl_plus/utils/ui/dialog/alert.dart';
import 'package:moegirl_plus/views/article/index.dart';
import 'package:moegirl_plus/views/contribution/index.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({Key key}) : super(key: key);

  void showOperationHelp() {
    showAlert<bool>(
      title: Lang.operationHelp,
      content: Lang.operationHelpContent
    );
  } 

  void toggleNight() {
    final isNight = settingsProvider.theme == 'night';
    if (isNight) {
      settingsProvider.theme = otherPref.lastTheme;
    } else {
      otherPref.lastTheme = settingsProvider.theme;
      settingsProvider.theme = 'night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget listItem(IconData icon, String text, onPressed) {      
      return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: theme.colorScheme.secondary.withOpacity(0.2),
          highlightColor: Colors.transparent,
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: [
                Icon(icon, size: 28, color: theme.colorScheme.secondary),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(text,
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 17
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      );
    }
    
    return LoggedInSelector(
      builder: (isLoggedIn) {
        return (
          SingleChildScrollView(
            child: Column(
              children: [
                listItem(Icons.forum, Lang.talkPage, () {
                  OneContext().pop();
                  OneContext().pushNamed('/article', arguments: ArticlePageRouteArgs(
                    pageName: RuntimeConstants.source == 'moegirl' ? '萌娘百科 talk:讨论版' : 'H萌娘讨论:讨论版'
                  ));
                }),
                listItem(Icons.format_indent_decrease, Lang.recentChanges, () {
                  OneContext().pop();
                  OneContext().pushNamed('/recentChanges');
                }),
                listItem(Icons.history, Lang.browseHistory, () {
                  OneContext().pop();
                  OneContext().pushNamed('/history');
                }),
                if (isLoggedIn) listItem(MaterialCommunityIcons.book_open_page_variant, Lang.myContribution, () {
                  OneContext().pop();
                  OneContext().pushNamed('/contribution', arguments: ContributionPageRouteArgs(userName: accountProvider.userName));
                }),
                listItem(Icons.touch_app, Lang.operationHelp, showOperationHelp),
                Selector<SettingsProviderModel, bool>(
                  selector: (_, provider) => provider.theme == 'night',
                  builder: (_, isNight, __) => listItem(Icons.brightness_4, Lang.toggleNightMode(isNight), toggleNight),
                )
              ],
            )
          )
        );
      },
    );
  }
}