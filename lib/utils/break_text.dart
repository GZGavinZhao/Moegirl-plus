// @dart=2.9
// 用于解决Text组件使用TextOverflow.ellipsis时，长字母、数字串整体被省略的问题
String breakText(String text) {
  return text.split('').join('\u200B');
}