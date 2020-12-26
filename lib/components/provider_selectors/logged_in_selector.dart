import 'package:flutter/material.dart';
import 'package:moegirl_plus/providers/account.dart';
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
      selector: (_, provider) => provider.isLoggedIn,
      builder: (_, isLoggedIn, __) => builder(isLoggedIn),
    );
  }
}