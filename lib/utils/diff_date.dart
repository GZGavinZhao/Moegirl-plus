import 'package:date_format/date_format.dart';

String diffDate(DateTime date) {
  final nowDate = DateTime.now();
  var diff = nowDate.millisecondsSinceEpoch - date.millisecondsSinceEpoch;
  diff = (diff.abs() / 1000).floor();
  var result = '';

  var needFullDate = false;
  if (diff < 60) {
    result = diff.toString() + '秒前';
  } else if (diff < 60 * 60) {
    result = (diff / 60).floor().toString() + '分钟前';
  } else if (diff < 60 * 60 * 24) {
    result = (diff / 60 / 60).floor().toString() + '小时前';
  } else if (diff < 60 * 60 * 24 * 30) {
    result = (diff / 60 / 60 / 24).floor().toString() + '天前';
    needFullDate = true;
  } else {
    result = formatDate(date, date.year != nowDate.year ? 
      [yyyy, '年', mm, '月', dd, '日'] :
      [m, '月', dd, '日']
    );
    needFullDate = true;
  }

  if (needFullDate) {
    final time = formatDate(date, [HH, ':', mm]);
    return '$result $time';
  } else {
    return result;
  }
}