import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_plus/api/comment.dart';
import 'package:moegirl_plus/utils/comment_tree.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class ProviderCommentData {
  List<Map> popular;
  List<Map> commentTree;
  int offset;
  int count;
  // 0：加载失败，1：初始，2：加载中，2.1：refresh加载中，3：加载成功，4：全部加载完成，5：加载过，但没有数据
  num status;

  ProviderCommentData({
    this.popular = const [],
    this.commentTree = const [],
    this.offset = 0,
    this.count = 0,
    this.status = 1
  });

  // 更新时利用是否为同一实例进行判断，和redux的思想同理。
  // 但为了便于书写，点赞的操作依然直接在原实例上进行，在使用时Selector需要选择到基本类型(点赞数int)
  ProviderCommentData clone() {
    return ProviderCommentData(
      popular: popular,
      commentTree: commentTree,
      offset: offset,
      count: count,
      status: status
    );
  }

  ProviderCommentData cloneWith({
    List<Map> popular,
    List<Map> commentTree,
    int offset,
    int count,
    num status,
  }) {
    return ProviderCommentData(
      popular: popular ?? this.popular,
      commentTree: commentTree ?? this.commentTree,
      offset: offset ?? this.offset,
      count: count ?? this.count,
      status: status ?? this.status
    );
  }

}

class CommentProviderModel with ChangeNotifier {
  Map<int, ProviderCommentData> data = {};

  Map findByCommentId(int pageId, String commentId, [bool popular = false]) {
    var foundItem = (popular ? data[pageId].popular : data[pageId].commentTree)
      .singleWhere((item) => item['id'] == commentId, orElse: () => null);
    if (foundItem != null || popular) return foundItem;

    foundItem = data[pageId].commentTree
      .fold<List<Map>>([], (result, item) => result + item['children'])
      .singleWhere((item) => item['id'] == commentId, orElse: () => null);

    return foundItem;
  }

  Future<void> loadNext(int pageId) async {    
    try {
      if (data[pageId] != null && [2, 2.1, 4, 5].contains(data[pageId].status)) return;
      data[pageId] ??= ProviderCommentData();
      data[pageId] = data[pageId].cloneWith(
        status: data[pageId].status == 1 ? 2.1 : 2
      );

      notifyListeners();

      final commentData = await CommentApi.getComments(pageId, data[pageId].offset);
      num nextStatus = 3;
      final int commentCount = commentData['posts'].where((item) => item['parentid'] == '').length;
      if (data[pageId].offset + commentCount >= commentData['count']) nextStatus = 4;
      if (data[pageId].commentTree.length == 0 && commentData['posts'].length == 0) nextStatus = 5;

      // 萌百的评论数据是用parentId格式串起来的，首先要树化，然后在第二层展平(将所有回复放在评论的children字段)
      final newCommentData = CommentTree(commentData['posts']).flatten().data;

      // 为数据带上请求时的offset
      newCommentData.forEach((item) => item['requestOffset'] = data[pageId].offset);

      data[pageId] = ProviderCommentData(
        popular: commentData['popular'].cast<Map>(),
        commentTree: [...data[pageId].commentTree, ...newCommentData].cast<Map>(),
        offset: data[pageId].offset + commentCount,
        count: commentData['count'],
        status: nextStatus
      );

      notifyListeners();
    } catch(e) {
      if (e is DioError) {
        data[pageId].status = 0;
        notifyListeners();
        return;
      }

      rethrow;
    }
  }

  Future<void> setLike(int pageId, String commentId, [bool like = true]) async {
    await CommentApi.toggleLike(commentId, like);
    final foundItem = findByCommentId(pageId, commentId);
    final foundPopularItem = findByCommentId(pageId, commentId, true);

    foundItem['like'] += like ? 1 : -1;
    foundItem['myatt'] = like ? 1 : 0;

    if (foundPopularItem != null) {
      foundPopularItem['like'] += like ? 1 : -1;
      foundPopularItem['myatt'] = like ? 1 : 0;
    }

    notifyListeners();
  }

  // 传入commentId表示回复
  Future<void> addComment(int pageId, String content, [String commentId]) async {
    await CommentApi.postComment(pageId, content, commentId);

    // 因为萌百的评论api没返回评论id，这里只好手动去查
    if (commentId == null) {
      // 如果发的是评论，获取最近10条评论，并找出新评论。
      // 当然这样是有缺陷的，如果从发评论到服务器响应之间新增评论超过10条，就会导致不准。{{黑幕|不过不用担心，你百是不可能这么火的}}
      final lastCommentList = await CommentApi.getComments(pageId);
      final currentCommentIds = data[pageId].commentTree.map((item) => item['id']).toList();
      final List<Map> newCommentList = lastCommentList['posts']
        .where((item) => item['parentid'] == '' && !currentCommentIds.contains(item['id']))
        .map((item) {
          item['children'] = <Map>[];
          item['requestOffset'] = 0;
          return item;
        })
        .cast<Map>()
        .toList();

      data[pageId].commentTree.insertAll(0, newCommentList);
      data[pageId].count++;
    } else {
      // 如果发的是回复，先找出回复的目标数据index
      final parentComment = data[pageId].commentTree.singleWhere((item) {
        if (item['id'] == commentId) return true;
        if (item['children'].any((childItem) => childItem['id'] == commentId)) return true;
        return false;
      });

      // 用回复目标的requestOffset请求，再找出回复目标数据，赋给当前渲染的评论数据，实现更新回复
      final newTargetCommentList = await CommentApi.getComments(pageId, parentComment['requestOffset']);
      // 调试这里
      final newTargetComment = CommentTree(newTargetCommentList['posts'])
        .flatten()
        .data.singleWhere((item) => item['id'] == parentComment['id'], orElse: () => null);

      if (newTargetComment != null) {
        newTargetComment['children'].forEach((item) => item['requestOffset'] = parentComment['requestOffset']);
        parentComment['children'] = newTargetComment['children'];
      }
    }

    if (data[pageId].status == 5) data[pageId].status = 4;
    data[pageId] = data[pageId].clone();
    notifyListeners();
  } 

  Future<void> remove(int pageId, String commentId, [String rootCommentId]) async {
    await CommentApi.delComment(commentId);

    final foundItem = findByCommentId(pageId, commentId);
    if (foundItem['parentid'] == '') {
      final targetIndex = data[pageId].commentTree.indexOf(foundItem);
      data[pageId].commentTree.removeAt(targetIndex);
    } else {
      // 如果不是根评论，则要找到其父评论，并收集其所有子评论，删除本身和其子评论
      final foundRootComment = findByCommentId(pageId, rootCommentId);
      final childrenCommentIdList = [commentId];

      // 递归查找子评论的子评论
      collectChildrenCommentId(List<String> idList) {
        final oldListLength = childrenCommentIdList.length;
        final resultIdList = foundRootComment['children']
          .where((item) => idList.contains(item['parentid']))
          .map((item) => item['id'])
          .cast<String>()
          .toList();
        childrenCommentIdList.addAll(resultIdList);
        if (oldListLength != childrenCommentIdList.length) {
          collectChildrenCommentId(resultIdList);
        }
      }

      collectChildrenCommentId([commentId]);
      foundRootComment['children'] = foundRootComment['children']
        .where((item) => !childrenCommentIdList.contains(item['id']))
        .toList();
    }

    if (data[pageId].commentTree.length == 0) data[pageId].status = 5;
    data[pageId] = data[pageId].clone();
    notifyListeners();
  }

  Future<void> refresh(int pageId) {
    data[pageId] = ProviderCommentData();
    notifyListeners();
    return loadNext(pageId);
  }
}

CommentProviderModel get commentProvider => Provider.of<CommentProviderModel>(OneContext().context, listen: false);