import 'package:flutter/material.dart';
import 'package:moegirl_plus/providers/settings.dart';
import 'package:moegirl_plus/utils/runtime_constants.dart';
import 'package:provider/provider.dart';

class DrawerScaffold extends StatelessWidget {
  final num width;
  final Widget header;
  final Widget body;
  final Widget footer;
  const DrawerScaffold({
    this.width,
    @required this.header,
    @required this.body,
    @required this.footer,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNight = Provider.of<SettingsProviderModel>(context).theme == 'night';
    
    return SizedBox(
    width: width,
      child: Drawer(
        child: Column(
          children: [
            header,
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  image: DecorationImage(
                    image: AssetImage('assets/images/${RuntimeConstants.source}/drawer_bg.png'),
                    fit: RuntimeConstants.source == 'moegirl' ? BoxFit.fitWidth : BoxFit.cover,
                    alignment: Alignment.topLeft,
                    colorFilter: ColorFilter.mode(
                      (isNight ? Colors.black : Colors.white).withOpacity(0.2), 
                    BlendMode.dstATop)
                  )
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: body,
                    ),
                    footer,
                  ],
                ),
              )
            )
          ],
        )
      ),
    );
  }
}