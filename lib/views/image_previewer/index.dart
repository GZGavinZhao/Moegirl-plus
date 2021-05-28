import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:alert/alert.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/request/plain_request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as P;

class ImagePreviewerPageRouteArgs {
  final List<String> imageUrlList;
  final int initialIndex;
  
  ImagePreviewerPageRouteArgs({
    this.imageUrlList,
    this.initialIndex = 1,
  });
}

class ImagePreviewerPage extends StatefulWidget {
  final ImagePreviewerPageRouteArgs routeArgs;
  ImagePreviewerPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _ImagePreviewerPageState createState() => _ImagePreviewerPageState();
}

class _ImagePreviewerPageState extends State<ImagePreviewerPage> {
  PageController pageController;
  
  @override
  void initState() { 
    super.initState();
    pageController = PageController(initialPage: widget.routeArgs.initialIndex);
  }

  void saveImg() async {
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      var currentImageUrl = widget.routeArgs.imageUrlList[pageController.page.toInt()];
      if (currentImageUrl.contains(RegExp(r'\.svg$'))) {
        final getSvgResponse = await plainRequest.get(currentImageUrl, 
          options: Dio.Options(
            responseType: Dio.ResponseType.bytes
          )
        );

        final svgDrawableRoot = await svg.fromSvgBytes(getSvgResponse.data, getSvgResponse.hashCode.toString());
        final pictureRecorder = PictureRecorder();
        final canvas = Canvas(pictureRecorder);
        final svgSize = svgDrawableRoot.viewport.size;
        svgDrawableRoot
          ..scaleCanvasToViewBox(canvas, svgSize)
          ..clipCanvasToViewBox(canvas)
          ..draw(canvas, Rect.fromLTWH(0, 0, svgSize.width, svgSize.height));
        final image = await pictureRecorder.endRecording().toImage(svgSize.width.toInt(), svgSize.height.toInt());
        final imageByteData = await image.toByteData(format: ImageByteFormat.png);

        final storagePath = (await getExternalStorageDirectory()).path;
        final savingName = Uri.decodeComponent(RegExp(r'.+\/(.+?)\.svg$').firstMatch(currentImageUrl).group(1));
        final savingPath = P.join(storagePath, 'willSaveImgs', savingName + '.png');
        final file = await File(savingPath).create(recursive: true);
        await file.writeAsBytes(Uint8List.view(imageByteData.buffer));
        currentImageUrl = savingPath;
      }

      final result = await GallerySaver.saveImage(currentImageUrl, albumName: 'DCIM/Moegirl+');
      if (result) {
        Alert(message: Lang.imagePreviewerPage_successHint).show();
      } else {
        Alert(message: Lang.imagePreviewerPage_failHint).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PhotoViewGallery(
              pageController: pageController,
              pageOptions: [
                for (var item in widget.routeArgs.imageUrlList) (
                  item.contains(RegExp(r'\.svg$')) ? 
                    PhotoViewGalleryPageOptions.customChild(
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      child: SvgPicture.network(item)
                    )
                  :
                    PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(item),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                    )
                )
              ],
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