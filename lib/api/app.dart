import 'package:moegirl_plus/request/plain_request.dart';

class AppApi {
  static Future getGithubLastRelease() {
    return plainRequest.get('https://api.github.com/repos/koharubiyori/Moegirl-plus/releases/latest')
      .then((res) => {
        'version': res.data['tag_name'],
        'downloadLink': res.data['assets'][0]['browser_download_url'],
        'desc': res.data['body']
      });
  }
}