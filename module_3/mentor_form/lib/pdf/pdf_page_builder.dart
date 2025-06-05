// ignore: dangling_library_doc_comments
///
/// This module is a work in progress and as such it
/// is not currently in use. The PdfPageBuilder
/// may be useful in the future, therefore I will leave
/// the code here for now
///
/// future use may look like this:

// final pageBuilder = PdfPageBuilder(
//     title: "Form Submission Summary",
//     document: document,
//     theme: theme,
//     showPageNumbers: true,
//   );

// pageBuilder.build([
//   Block(
//     width: document.pageSettings.width,
//     height: 0,
//     children: [
//       Block(
//         width: PdfLayoutSpec.labelWidth,
//         height: 0,
//         children: [TextElement(text: 'Mentor Name:', font: theme.label.font)],
//       ),
//       Block(
//         width: 0,
//         height: 0,
//         children: [
//           TextElement(text: 'Dusti Johnson', font: theme.paragraph.font),
//         ],
//       ),
//     ],
//   ),
// ]);

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'pdf_theme.dart';

class PdfPageBuilder {
  final String title;
  final PdfDocument document;
  final PdfTheme theme;
  final bool showPageNumbers;

  const PdfPageBuilder({
    required this.title,
    required this.document,
    required this.theme,
    this.showPageNumbers = false,
  });

  void build(List<BlockChild> children) {}
}

abstract interface class BlockChild {}

class Block implements BlockChild {
  final double width;
  final double height;
  final List<BlockChild> children;

  const Block({this.width = 0, this.height = 0, this.children = const []});
}

class TextElement implements BlockChild {
  final String text;
  final PdfFont font;

  const TextElement({required this.text, required this.font});
}
