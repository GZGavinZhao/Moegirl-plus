String trimHtml(String html) {
  return html
    .replaceAll(RegExp(r'(<.+?>|<\/.+?>)'), '')
    .replaceAllMapped(RegExp(r'&(.+?);'), (match) => {
      'gt': '>',
      'lt': '<',
      'amp': '&'
    }[match[1]] ?? match[0])
    .trim();
}