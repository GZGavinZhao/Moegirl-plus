import 'package:flutter/material.dart';

class StyledCircularProgressIndicator extends StatelessWidget {
  const StyledCircularProgressIndicator({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary)
    );
  }
}