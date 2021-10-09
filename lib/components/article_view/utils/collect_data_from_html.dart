// @dart=2.9
import 'package:html/parser.dart';

CollectedCategoryDataFromHtml collectCategoryDataFromHtml(String html) {
  final htmlDoc = parse(html);
  final parentCategoriesContainer = htmlDoc.getElementById('topicpath');
  final descContainer = htmlDoc.getElementById('catmore');
  List<String> parentCategories;
  String categoryExplainPageName;

  if (parentCategoriesContainer != null) {
    parentCategories = parentCategoriesContainer
      .getElementsByTagName('a')
      .map((item) => item.text)
      .toList();
  }

  if (descContainer != null) {
    categoryExplainPageName = descContainer.getElementsByTagName('a')[0].attributes['title'];
  }

  return CollectedCategoryDataFromHtml(
    parentCategories: parentCategories,
    categoryExplainPageName: categoryExplainPageName
  );
}

class CollectedCategoryDataFromHtml {
  final List<String> parentCategories;
  final String categoryExplainPageName;

  CollectedCategoryDataFromHtml({
    this.parentCategories,
    this.categoryExplainPageName
  });
}