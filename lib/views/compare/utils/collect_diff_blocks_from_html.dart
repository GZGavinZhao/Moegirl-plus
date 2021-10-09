// @dart=2.9
import 'package:html/dom.dart' as htmlDom;
import 'package:html/parser.dart';

List<DiffBlock> collectDiffBlocksFromHtml(String html) {
  final htmlDoc = parse(html);
  final List<DiffBlock> diffBlocks = [];

  htmlDoc.querySelectorAll('tr').forEach((item) {
    if (item.querySelector('.diff-lineno') != null) {
      final leftLineHint = item.querySelector('.diff-lineno:first-child').text;
      final rightLineHint = item.querySelector('.diff-lineno:last-child').text;
      
      final diffBlock = DiffBlock(
        left: DiffLine(lineHint: leftLineHint, rows: []),
        right: DiffLine(lineHint: rightLineHint, rows: [])
      );

      diffBlocks.add(diffBlock);
    } else {
      // 如果一行中出现了上下文，那一定会左右都有内容，且没有修改的内容标志
      if (item.querySelector('.diff-context') != null) {
        final contextsEls = item.querySelectorAll('.diff-context');
        diffBlocks.last.left.rows.add(
          DiffRow(
            marker: DiffRowMarker.none,
            content: [DiffRowContent(type: DiffRowContentType.plain, text: contextsEls.first.text)]
          )
        );
        diffBlocks.last.right.rows.add(
          DiffRow(
            marker: DiffRowMarker.none,
            content: [DiffRowContent(type: DiffRowContentType.plain, text: contextsEls.last.text)]
          )
        );

        return;
      }

      // 解析内容行
      final leftRow = DiffRow(marker: DiffRowMarker.none, content: []);
      final rightRow = DiffRow(marker: DiffRowMarker.none, content: []);

      final deletedLineEl = item.querySelector('.diff-deletedline');
      final addedLineEl = item.querySelector('.diff-addedline');

      if (deletedLineEl != null) {
        leftRow.marker = DiffRowMarker.minus;
        final deletedLineContentNodeEls = deletedLineEl.querySelector('div').nodes;

        deletedLineContentNodeEls.forEach((node) {
          DiffRowContent diffContent;
          
          if (node is htmlDom.Text) {
            diffContent = DiffRowContent(
              type: DiffRowContentType.plain,
              text: node.text
            );
          }
          if (node is htmlDom.Element) {
            diffContent = DiffRowContent(
              type: DiffRowContentType.delete,
              text: node.text
            );
          }

          leftRow.content.add(diffContent);
        });
      }

      if (addedLineEl != null) {
        rightRow.marker = DiffRowMarker.plus;
        final addedLineContentNodeEls = addedLineEl.querySelector('div').nodes;
        
        addedLineContentNodeEls.forEach((node) {
          DiffRowContent diffContent;
          
          if (node is htmlDom.Text) {
            diffContent = DiffRowContent(
              type: DiffRowContentType.plain,
              text: node.text
            );
          }
          if (node is htmlDom.Element) {
            diffContent = DiffRowContent(
              type: DiffRowContentType.add,
              text: node.text
            );
          }

          rightRow.content.add(diffContent);
        });
      }

      diffBlocks.last.left.rows.add(leftRow);
      diffBlocks.last.right.rows.add(rightRow);
    }
  });

  return diffBlocks;
}

class DiffBlock {
  DiffLine left;
  DiffLine right;
  
  DiffBlock({ this.left, this.right });
}

class DiffLine {
  String lineHint;
  List<DiffRow> rows;

  DiffLine({ this.lineHint, this.rows });  
}

enum DiffRowMarker {
  plus, minus, none
}

class DiffRow {
  DiffRowMarker marker;
  List<DiffRowContent> content;

  DiffRow({ this.marker, this.content });
}

enum DiffRowContentType {
  plain, add, delete
}

class DiffRowContent {
  DiffRowContentType type; 
  String text;

  DiffRowContent({ this.type, this.text });
}