import 'dart:convert';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'pdf_theme.dart';
import 'pdf_page_builder.dart';

Future<void> generateAndDownloadPDF(
  String mentorName,
  String studentName,
  String sessionDetails,
  String notes,
) async {
  PdfDocument document = PdfDocument();

  final theme = await PdfTheme.loadDefault();

  final pageBuilder = PdfPageBuilder(
    document: document,
    theme: theme,
    showPageNumbers: true,
  );

  Uint8List bytes = await document.saveAsBytes();
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
