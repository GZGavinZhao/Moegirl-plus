// @dart=2.9
import 'package:moegirl_plus/request/plain_request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

// 返回null代表未授予权限
Future<DownloadFileResult> downloadFile(String fileUrl, String fileName) async {
  final permissionStatus = await Permission.storage.request();
  if (permissionStatus.isGranted) {
    try {
      final savePath = await _getFileSavePath(fileName);
      plainRequest.download(fileUrl, savePath);
      return DownloadFileResult(DownloadFileResultStatus.success, savePath);
    } catch(e) {
      print('下载文件失败：$fileUrl');
      print(e);
      return DownloadFileResult(DownloadFileResultStatus.netErr);
    }
  }

  return DownloadFileResult(DownloadFileResultStatus.denied);
}

_getFileSavePath(String fileName) async {
  final storagePath = (await getExternalStorageDirectory()).path;
  return p.join(storagePath, fileName);
}

class DownloadFileResult {
  final DownloadFileResultStatus status;
  final String savedPath;

  DownloadFileResult(this.status, [this.savedPath]);
}

enum DownloadFileResultStatus {
  success, netErr, denied
}