import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'pdf_theme.dart';
import 'pdf_layout_spec.dart';

Future<void> generateAndDownloadPDF(
  String mentorName,
  String studentName,
  String sessionDetails,
  String notes,
) async {
  PdfDocument document = PdfDocument();
  document.pageSettings.margins.all = PdfLayoutSpec.margin;

  final page = document.pages.add();

  final pageWidth = page.getClientSize().width;
  final pageHeight = page.getClientSize().height;

  final theme = await PdfTheme.loadDefault();
  final bitmap = PdfBitmap(await _readImageData('CSC_logo_500x173.png'));

  // Logo
  page.graphics.drawImage(
    bitmap,
    Rect.fromLTWH(0, 0, PdfLayoutSpec.logoWidth, PdfLayoutSpec.logoHeight),
  );

  // Title
  var textElement = PdfTextElement(
    text: 'Form Submission Summary',
    font: theme.title.font,
  );

  var y = PdfLayoutSpec.logoHeight + PdfLayoutSpec.titlePaddingTop;
  var layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, pageWidth, 0),
  );

  // Divider
  y = layoutResult!.bounds.bottom + PdfLayoutSpec.titlePaddingBottom;
  page.graphics.drawLine(
    PdfPen(PdfColor(0, 0, 0), width: PdfLayoutSpec.titleDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // Mentor Name
  y += PdfLayoutSpec.bodyGap;
  textElement.text = 'Mentor Name:';
  textElement.font = theme.label.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  textElement.text = 'Dusti Johnson';
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(layoutResult!.bounds.right, y, 0, 0),
  );

  // Divider
  y = layoutResult!.bounds.bottom + PdfLayoutSpec.bodyGap;
  page.graphics.drawLine(
    PdfPen(PdfColor(204, 204, 204), width: PdfLayoutSpec.bodyDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // Student Name
  y += PdfLayoutSpec.bodyGap;
  textElement.text = 'Student Name:';
  textElement.font = theme.label.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  textElement.text = 'Bob Saget';
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(layoutResult!.bounds.right, y, 0, 0),
  );

  // Divider
  y = layoutResult!.bounds.bottom + PdfLayoutSpec.bodyGap;
  page.graphics.drawLine(
    PdfPen(PdfColor(204, 204, 204), width: PdfLayoutSpec.bodyDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // Session Details
  y += PdfLayoutSpec.bodyGap;
  textElement.text = 'Session Details:';
  textElement.font = theme.label.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  textElement.text = 'Topeka Public Library, June 4, 2025, 6:30 PM';
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(layoutResult!.bounds.right, y, 0, 0),
  );

  // Divider
  y = layoutResult!.bounds.bottom + PdfLayoutSpec.bodyGap;
  page.graphics.drawLine(
    PdfPen(PdfColor(204, 204, 204), width: PdfLayoutSpec.bodyDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // TODO: Notes

  // Divider
  y = pageHeight - PdfLayoutSpec.footerHeight;
  page.graphics.drawLine(
    PdfPen(PdfColor(0, 0, 0)),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  // Footer
  y += PdfLayoutSpec.footerGapToPageNum;
  textElement.text = '1 of 1';
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.pageNumBoxWidth, 0),
  );

  y -= PdfLayoutSpec.footerGapToPageNum;
  y += PdfLayoutSpec.footerGapToInfo;
  textElement.text =
      '2518 Ridge Ct, Suite 208\nLawrence, KS 66046\nwww.supportivecommunities.org';

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(layoutResult!.bounds.right, y, 0, 0),
  );

  // Save and dispose
  final bytes = await document.saveAsBytes();
  document.dispose();

  if (kIsWeb) {
    _downloadPDF(bytes, 'Form Submission Summary.pdf');
  }
}

Future<void> _downloadPDF(Uint8List bytes, String filename) async {
  final base64 = base64Encode(bytes);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = 'data:application/pdf;base64,$base64'
    ..download = filename;
  web.document.body!.appendChild(anchor);
  anchor.click();
  web.document.body!.removeChild(anchor);
}

Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load('assets/images/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
