// 树化
List _toCommentTree(List data) {
  final roots = data.where((item) => item['parentid'] == '');
  roots.forEach((item) {
    item['children'] = _getChildrenById(item, data);
  });

  return roots.toList();
}

// 获取一条评论下所有回复
List _getChildrenById(Map root, List data) {
  List through(dynamic root) {
    final result = [];
    data.forEach((item) {
      if (root['id'] == item['parentid']) {
        item['children'] = through(item);
        result.add(item);
      }
    });

    return result;
  }

  return through(root);
}

class CommentTree {
  List data;

  CommentTree(rawData) {
    data = _toCommentTree(rawData);
  }

  // 为回复带上回复对象(target)的数据
  static List withTargetData(List children, String selfId) {
    return children.map((item) {
      if (item['parentid'] != selfId) {
        item['target'] = children.singleWhere((childItem) => childItem['id'] == item['parentid']);
        return item;
      }
    });
  }

  static List flattenItem(List children) {
    return children.fold<List>([], (result, item) {
      final children = item['children'] ?? [];
      return [item, ...flattenItem(children)];
    });
  }

  // 从第二层开始扁平化
  void flatten() {
    data.forEach((item) => item['children'] = flattenItem(item['children']));
  }
}
