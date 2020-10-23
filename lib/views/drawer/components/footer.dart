import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => OneContext().pushNamed('/settings'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, size: 22, color: theme.hintColor),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('设置', style: TextStyle(color: theme.hintColor)),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            alignment: Alignment.center,
            child: Container(
              color: theme.dividerColor,
              height: 40 * 0.6
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.subdirectory_arrow_left, size: 22, color: theme.hintColor),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('退出应用', style: TextStyle(color: theme.hintColor)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}