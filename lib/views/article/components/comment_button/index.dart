import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/views/article/components/comment_button/components/animation.dart';

class ArticlePageCommentButton extends StatefulWidget {
  final String text;
  final void Function(ArticlePageCommentButtonAnimationMainController) emitController;
  final Function onPressed;
  
  ArticlePageCommentButton({
    @required this.text,
    @required this.emitController,
    @required this.onPressed,
    Key key
  }) : super(key: key);

  @override
  _ArticlePageCommentButtonState createState() => _ArticlePageCommentButtonState();
}

class _ArticlePageCommentButtonState extends State<ArticlePageCommentButton> {
  final buttonAnimationControllerCompleter = Completer<ArticlePageCommentButtonAnimationController>();
  // final rippleLayerAnimationControllerCompleter = Completer<ArticlePageCommentButtonRippleAnimationController>();

  @override
  void initState() { 
    super.initState();
    
    Future.wait([
      buttonAnimationControllerCompleter.future,
      // rippleLayerAnimationControllerCompleter.future
    ])
      .then((controllers) {
        final ArticlePageCommentButtonAnimationController buttonController = controllers[0];
        // final ArticlePageCommentButtonRippleAnimationController rippleContorller = controllers[1];

        if (widget.emitController != null) {
          widget.emitController(ArticlePageCommentButtonAnimationMainController(
            buttonController.show,
            buttonController.hide,
            // rippleContorller.show
            () async {}
          ));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ArticlePageCommentButtonAnimation(
      emitController: buttonAnimationControllerCompleter.complete,
      child: Stack(
        children: [
          // ArticlePageCommentButtonRippleAnimationLayer(
          //   emitController: rippleLayerAnimationControllerCompleter.complete,
          // ),
          Material(
            color: Colors.transparent,
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: TouchableOpacity(
              onPressed: widget.onPressed,
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: SizedBox.expand(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment, size: 28, color: theme.colorScheme.onPrimary),
                        Text(widget.text,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 13
                          ),
                        )
                      ]
                    ),
                  )
                ),
              ),
            )
          )
        ],
      )
    );
  }
}

class ArticlePageCommentButtonAnimationMainController {
  final Future<void> Function() show;
  final Future<void> Function() hide;
  final Future<void> Function() ripple;

  ArticlePageCommentButtonAnimationMainController(this.show, this.hide, this.ripple);  
}