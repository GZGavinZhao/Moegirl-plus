import 'package:date_format/date_format.dart';

String diffDate(DateTime date) {
  final nowDate = DateTime.now();
  var diff = nowDate.millisecondsSinceEpoch - date.millisecondsSinceEpoch;
  diff = diff.floor();
  var result = '';

  var needFullDate = false;
  if (diff < 60) {
    result = diff.toString() + '秒前';
  } else if (diff < 60 * 60) {
    result = (diff / 60).toString() + '分钟前';
  } else if (diff < 60 * 60 * 24) {
    result = (diff / 60 / 60).toString() + '小时前';
  } else if (diff < 60 * 60 * 24 * 30) {
    result = (diff < 60 * 60 * 24).toString() + '天前';
    needFullDate = true;
  } else {
    result = formatDate(date, [yyyy, '年', mm, '月', dd, '日']);
    needFullDate = true;
  }

  if (needFullDate) {
    final time = formatDate(date, [hh, ':', mm]);
    return '$result $time';
  } else {
    return result;
  }
}