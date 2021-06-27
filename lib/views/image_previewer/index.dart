import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:alert/alert.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:moegirl_plus/components/article_view/index.dart';
import 'package:moegirl_plus/components/touchable_opacity.dart';
import 'package:moegirl_plus/language/index.dart';
import 'package:moegirl_plus/request/plain_request.dart';
import 'package:path/path.dart' as P;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewerPageRouteArgs {
  final List<MoegirlImage> images;
  final int initialIndex;
  
  ImagePreviewerPageRouteArgs({
    this.images,
    this.initialIndex = 1,
  });
}

class ImagePreviewerPage extends StatefulWidget {
  final ImagePreviewerPageRouteArgs routeArgs;
  ImagePreviewerPage(this.routeArgs, {Key key}) : super(key: key);
  
  @override
  _ImagePreviewerPageState createState() => _ImagePreviewerPageState();
}

class _ImagePreviewerPageState extends State<ImagePreviewerPage> with AfterLayoutMixin {
  PageController pageController;
  int currentImgIndex = 0;
  
  @override
  void initState() { 
    super.initState();
    currentImgIndex = widget.routeArgs.initialIndex;
    pageController = PageController(initialPage: widget.routeArgs.initialIndex);

    pageController.addListener(() {
      setState(() => currentImgIndex = pageController.page.toInt());  
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.routeArgs.images.forEach((item) {
      item.fileUrl.contains(RegExp(r'\.svg$')) ?  
        precachePicture(SvgPicture.network(item.fileUrl).pictureProvider, context) :
        precacheImage(NetworkImage(item.fileUrl), context);
    });
  }

  void saveImg() async {
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      var currentImageUrl = widget.routeArgs.images[pageController.page.toInt()].fileUrl;
      // 如果图片为svg，则需要先将其置于canvas，再转为png之后存在缓存目录，把路径传给GallerySaver
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
        Alert(message: Lang.imageSavedToAlbum).show();
      } else {
        Alert(message: Lang.imageSaveFail).show();
      }
    } else {
      Alert(message: Lang.imageSavePermissionErrHint);
    }
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              children: [
                for (var item in widget.routeArgs.images) _PhotoViewPage(imageUrl: item.fileUrl)
              ],
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
            ),

            if (widget.routeArgs.images.length > 1) (
              Positioned(
                left: 20,
                bottom: 20,
                // height: 50,
                width: MediaQueryData.fromWindow(window).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${Lang.gallery}：${currentImgIndex + 1} / ${widget.routeArgs.images.length}',
                      style: TextStyle(color: Color(0xffcccccc)),
                    ),
                    Text(widget.routeArgs.images[currentImgIndex].title,
                      style: TextStyle(color: Color(0xffcccccc))
                    )
                  ],
                ),
              )
            )
          ],  
        ),
      )
    );
  }
}

class _PhotoViewPage extends StatefulWidget {
  final String imageUrl;
  _PhotoViewPage({
    this.imageUrl,
    Key key,
  }) : super(key: key);

  @override
  __PhotoViewPageState createState() => __PhotoViewPageState();
}

class __PhotoViewPageState extends State<_PhotoViewPage> with AutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;
  bool isLoading = false;
  SvgPicture svgPicture;

  get isSvg => widget.imageUrl.contains(RegExp(r'\.svg$'));

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final loadingWidget = Container(
      alignment: Alignment.center,
      color: Colors.black,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );

    return Container(
      child: isSvg ?
        PhotoView.customChild(
          minScale: PhotoViewComputedScale.contained * 0.8,
          child: SvgPicture.network(widget.imageUrl, placeholderBuilder: (_) => loadingWidget),
        ) 
      :
        PhotoView(
          minScale: PhotoViewComputedScale.contained * 0.8,
          loadingBuilder: (_, __) => loadingWidget,
          imageProvider: NetworkImage(widget.imageUrl),
        )
      ,
    );
  }
}