import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewerPageRouteArgs {
  final String imageUrl;
  
  ImagePreviewerPageRouteArgs({
    this.imageUrl
  });
}

class ImagePreviewerPage extends StatefulWidget {
  final ImagePreviewerPageRouteArgs routeArgs;
  ImagePreviewerPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _ImagePreviewerPageState createState() => _ImagePreviewerPageState();
}

class _ImagePreviewerPageState extends State<ImagePreviewerPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.routeArgs.imageUrl),
        ),
      )
    );
  }
}