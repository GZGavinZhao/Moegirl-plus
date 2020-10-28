import 'package:moegirl_viewer/request/moe_request.dart';

class CommentApi {
  static Future<Map> getComments(int pageId, [int offset = 0]) {
    return moeRequest(
      params: {
        'action': 'flowthread',
        'type': 'list',
        'pageid': pageId,
        'offset': offset
      }
    )
      .then((data) => data['flowthread']);
  }

  static Future toggleLike(String postId, bool like) {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'flowthread',
        'type': like ? 'like' : 'dislike',
        'postid': postId
      }
    )
      .then((data) {
        if (data.containsKey('error')) throw Exception;
      });
  }

  static Future<bool> report(String postId) {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'flowthread',
        'type': 'report',
        'postid': postId
      }
    )
      .then((data) {
        if (data.containsKey('error')) throw Exception;
      });
  }

  static Future<bool> delComment(String postId) {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'flowthread',
        'type': 'delete',
        'postid': postId
      }
    )
      .then((data) {
        if (data.containsKey('error')) throw Exception;
      });
  }

  static Future<void> postComment(int pageId, String content, [String postId]) {
    return moeRequest(
      method: 'post',
      params: {
        'action': 'flowthread',
        'type': 'post',
        'pageid': pageId,
        'content': content,
        ...(postId != null ? { 'postid': postId } : {})
      }
    )
      .then((data) {
        if (data.containsKey('error')) throw Exception;
      });
  }
}