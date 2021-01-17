import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewerPageRouteArgs {
  final String imageUrl;
  
  ImagePreviewerPageRouteArgs({
    @required this.imageUrl
  });
}

class ImagePreviewerPage extends StatefulWidget {
  final ImagePreviewerPageRouteArgs routeArgs;
  ImagePreviewerPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _ImagePreviewerPageState createState() => _ImagePreviewerPageState();
}

class _ImagePreviewerPageState extends State<ImagePreviewerPage> {
  
  void saveImg() async {
    final result = await GallerySaver.saveImage(widget.routeArgs.imageUrl, albumName: 'DCIM/Moegirl+');
    if (result) {
      Alert(message: l.imagePreviewerPage_successHint).show();
    } else {
      Alert(message: l.imagePreviewerPage_failHint).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(widget.routeArgs.imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              loadingBuilder: (context, event) => (
                Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              ),
            ),

            Positioned(
              right: 20,
              bottom: 20,
              child: TouchableOpacity(
                onPressed: saveImg,
                child: Icon(Icons.file_download,
                  color: Color(0xffeeeeee).withOpacity(0.5),
                  size: 35,
                ),
              ),
            )
          ],  
        ),
      )
    );
  }
}