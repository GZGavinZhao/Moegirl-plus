import 'package:flutter/material.dart';
import 'package:moegirl_viewer/providers/account.dart';
import 'package:provider/provider.dart';

class LoggedInSelector extends StatelessWidget {
  final Widget Function(bool isLoggedIn) builder;

  const LoggedInSelector({
    @required this.builder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AccountProviderModel, bool>(
      selector: (_, model) => model.isLoggedIn,
      builder: (_, isLoggedIn, __) => builder(isLoggedIn),
    );
  }
}