// @dart=2.9
import 'package:moegirl_plus/api/app.dart';
import 'package:package_info/package_info.dart';

// ignore: missing_return
Future<AppNewVersionInfo> checkNewVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  try {
    final data = await AppApi.getGithubLastRelease();
    final lastReleasedVersion = int.parse(data['version'].replaceAll('.', ''));
    final currentVersion = int.parse(packageInfo.version.replaceAll('.', ''));
    if (lastReleasedVersion > currentVersion) {
      return AppNewVersionInfo(version: data['version'], desc: data['desc']);
    }

    return null;
  } catch(e) {
    print('检查新版本失败');
    print(e);
  }
}

class AppNewVersionInfo {
  final String version;
  final String desc;

  AppNewVersionInfo({
    this.version,
    this.desc
  });
}