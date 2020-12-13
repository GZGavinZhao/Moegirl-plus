

EditComment parseEditSummary(String comment) {
  final sectionRegex = RegExp(r'\/\* (.+?) \*\/');
  final body = comment.replaceFirst(sectionRegex, '');
  return EditComment(
    body: body.trim() != '' ? body.trim() : null,
    section: sectionRegex.firstMatch(comment)?.group(1)
  );
}

class EditComment {
  final String body;
  final String section;

  EditComment({
    this.body,
    this.section
  });
}