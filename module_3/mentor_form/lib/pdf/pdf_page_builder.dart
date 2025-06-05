import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'pdf_theme.dart';

class PdfPageBuilder {
  final PdfDocument document;
  final PdfTheme theme;
  final bool showPageNumbers;

  const PdfPageBuilder({
    required this.document,
    required this.theme,
    this.showPageNumbers = false,
  });

  void addHeader() {}
  void addBody() {}
  void addFooter() {}
}
