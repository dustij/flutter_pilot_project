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

  var y = 0.0;
  var textElement = PdfTextElement(text: '');

  // Header
  final header = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, pageWidth, PdfLayoutSpec.headerHeight),
  );

  header.graphics.drawImage(
    bitmap,
    Rect.fromLTWH(0, 0, PdfLayoutSpec.logoWidth, PdfLayoutSpec.logoHeight),
  );

  textElement = PdfTextElement(
    text: 'Form Submission Summary',
    font: theme.title.font,
  );

  y = PdfLayoutSpec.logoHeight + PdfLayoutSpec.titlePaddingTop;
  header.graphics.drawString(
    'Form Submission Summary',
    theme.title.font,
    bounds: Rect.fromLTWH(0, y, pageWidth, PdfLayoutSpec.headerHeight),
  );

  y = header.bounds.bottom - PdfLayoutSpec.titleDividerPaddingBottom;
  header.graphics.drawLine(
    PdfPen(PdfColor(0, 0, 0), width: PdfLayoutSpec.titleDividerThickness),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  document.template.top = header;

  // Mentor Name
  y = 0;
  textElement.text = 'Mentor Name:';
  textElement.font = theme.label.font;

  var layoutResult = textElement.draw(
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

  // Notes
  y += PdfLayoutSpec.bodyGap;
  textElement.text = 'Notes:';
  textElement.font = theme.label.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, PdfLayoutSpec.labelWidth, 0),
  );

  final notesTextBounds = Rect.fromLTWH(
    layoutResult!.bounds.right,
    y,
    pageWidth - PdfLayoutSpec.labelWidth,
    pageHeight - PdfLayoutSpec.footerHeight - PdfLayoutSpec.headerHeight - y,
  );

  final notesTextPaginationBounds = Rect.fromLTWH(
    layoutResult.bounds.right,
    0,
    pageWidth - PdfLayoutSpec.labelWidth,
    pageHeight - PdfLayoutSpec.footerHeight - PdfLayoutSpec.headerHeight,
  );

  final PdfLayoutFormat format = PdfLayoutFormat(
    layoutType: PdfLayoutType.paginate,
    breakType: PdfLayoutBreakType.fitPage,
    paginateBounds: notesTextPaginationBounds,
  );

  textElement.text =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut id convallis elit. Nulla rutrum vitae nulla quis tempus. In nec auctor neque. Suspendisse id tincidunt mauris. Quisque vel tincidunt leo. In mattis placerat turpis at auctor. Morbi eu hendrerit ex. Duis facilisis vestibulum quam, et dapibus eros mattis sed. Pellentesque blandit leo enim, sed pulvinar enim pellentesque vel. Cras vestibulum, est et ultrices pharetra, lacus sapien tempus enim, non auctor risus arcu eu nulla. Pellentesque nec dignissim eros.\n\nMaecenas elementum mollis nisi. Nulla sed nisl cursus, viverra mi quis, malesuada mauris. Pellentesque interdum malesuada commodo. Nulla non placerat diam. Pellentesque at facilisis nunc, quis tempus neque. Aenean placerat volutpat justo, cursus viverra ex auctor non. Nullam ut sem lobortis, molestie nibh vitae, ultrices dolor.\n\nProin eget diam quis eros rutrum auctor ut a elit. Nullam quis ullamcorper libero, in semper massa. Pellentesque nec quam nulla. Morbi tortor lorem, porttitor a tincidunt quis, consequat sit amet enim. Nullam sed risus dui. Curabitur imperdiet gravida venenatis. Morbi vitae tortor sem. Nulla facilisi. Nulla pellentesque metus non sapien placerat consectetur. Nam ac semper urna. Proin lorem lacus, rhoncus eget nibh a, fringilla maximus orci. Proin feugiat ante dolor, et tincidunt arcu vestibulum eu. Sed laoreet, nulla ut suscipit varius, odio magna volutpat ligula, sit amet facilisis nulla erat ut lacus.\n\nDonec at venenatis mi, ac pellentesque velit. Cras laoreet turpis nec finibus blandit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Ut iaculis id dui in condimentum. Vivamus ultrices ultrices nisi, eu fringilla eros pharetra et. Integer mollis finibus lectus. In tristique, turpis sit amet sodales porttitor, risus lacus egestas massa, at ornare nibh magna et mauris. Etiam ipsum lacus, convallis id porta quis, facilisis a ex. Quisque sed enim scelerisque, vulputate purus at, mattis erat. Praesent suscipit nunc nec blandit sagittis.\n\nDonec at fermentum sem. Phasellus aliquet nisl et purus porta, vitae ultrices libero mollis. Donec finibus lorem id mi rutrum commodo. Donec elementum euismod elit, eget bibendum libero convallis in. Mauris mattis bibendum scelerisque. Nulla urna orci, consequat nec turpis quis, iaculis congue tellus. Nulla vel magna dapibus lectus tristique egestas a ut tortor. In molestie ornare viverra. Nunc ullamcorper quam leo, accumsan pellentesque neque finibus sed. Mauris faucibus massa quam, sit amet blandit nisi tincidunt at. Nulla vulputate eros nec lacus maximus, eget tempor odio tristique. Donec ullamcorper sit amet purus eu ultrices. Curabitur ut quam nec justo porttitor convallis. Aenean eget venenatis enim, id pretium nulla. Praesent ac arcu vitae lorem varius tincidunt. Proin lorem dui, elementum vitae blandit vel, gravida sit amet orci.\nNullam sodales urna arcu, fringilla rhoncus urna tincidunt in. Donec rutrum orci justo. Sed vitae tempor nulla, in viverra diam. Proin fringilla tellus ipsum. In eu lectus eu velit ornare iaculis vitae ut metus. Sed egestas fringilla molestie. Ut varius ex at erat interdum tincidunt. Vivamus ut ipsum luctus, faucibus nisi et, euismod sem. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Integer mollis eu leo hendrerit scelerisque. Curabitur malesuada velit id fermentum imperdiet. Morbi et tristique urna.\nNunc auctor volutpat massa, quis iaculis erat pulvinar id. Curabitur lacinia elit ac fringilla consequat. Aenean vulputate vel turpis quis finibus. Aenean eu purus nulla. Pellentesque viverra velit nec ipsum rutrum laoreet. Sed non mattis risus. Nullam egestas efficitur nisi, in dictum purus dictum efficitur. Nam quis lacus rutrum sem porta euismod ut ac sem. Phasellus sit amet maximus dolor. Quisque rhoncus venenatis libero ac sollicitudin. Pellentesque finibus nec lorem et finibus.\nDonec at massa mollis, blandit metus vitae, ultrices urna. Praesent finibus diam sed lectus varius efficitur. Morbi aliquam ipsum sit amet varius tincidunt. Aliquam feugiat urna ut ligula mollis, in luctus justo interdum. In sed metus ut risus pretium sagittis. Morbi ornare mauris aliquam lectus consequat sagittis. Nullam placerat vulputate turpis vitae luctus. Etiam ultricies efficitur justo, vitae vulputate mauris dictum eu. Integer cursus auctor pulvinar. Suspendisse potenti./nInteger vitae elementum ex. Phasellus facilisis odio eget ultricies posuere. Sed quis elementum orci, pretium volutpat enim. Nam cursus eget eros et hendrerit. Suspendisse ornare non neque ac dapibus. Nulla nec eros vitae mauris vehicula lobortis tincidunt id augue. Maecenas non purus volutpat metus ullamcorper lobortis quis in nisi. Aliquam in augue convallis, dignissim arcu non, ultricies augue. Nulla tincidunt lorem ac diam congue suscipit. Vestibulum consequat ex nec enim vestibulum vestibulum. Cras aliquet dolor justo, ac sagittis sem ultrices id. Integer interdum eleifend blandit. Integer quis orci vitae lacus elementum tincidunt quis ac neque. Donec felis sapien, ultricies non ipsum vel, convallis pretium lacus.\nEtiam at diam a turpis congue imperdiet ac vitae nulla. Donec ultricies mi massa, non suscipit libero tempus ac. Nunc in ipsum hendrerit, dictum mauris ac, condimentum nibh. Ut sed sodales risus. Morbi rhoncus libero augue, at mollis urna vehicula nec. Proin sed.';
  textElement.font = theme.paragraph.font;

  layoutResult = textElement.draw(
    page: page,
    bounds: notesTextBounds,
    format: format,
  );
  // Footer
  y = pageHeight - PdfLayoutSpec.footerHeight;
  final footer = PdfPageTemplateElement(
    Rect.fromLTWH(0, y, pageWidth, PdfLayoutSpec.footerHeight),
  );

  y = PdfLayoutSpec.footerDividerPaddingTop;
  footer.graphics.drawLine(
    PdfPen(PdfColor(0, 0, 0)),
    Offset(0, y),
    Offset(pageWidth, y),
  );

  final pageNumber = PdfPageNumberField(font: theme.paragraph.font);
  final count = PdfPageCountField(font: theme.paragraph.font);

  PdfCompositeField compositeField = PdfCompositeField(
    font: theme.paragraph.font,
    text: '{0} of {1}',
    fields: <PdfAutomaticField>[pageNumber, count],
  );

  y += PdfLayoutSpec.footerGapToPageNum;
  compositeField.draw(footer.graphics, Offset(0, y));

  y -= PdfLayoutSpec.footerGapToPageNum;
  y += PdfLayoutSpec.footerGapToInfo;
  footer.graphics.drawString(
    '2518 Ridge Ct, Suite 208\nLawrence, KS 66046\nwww.supportivecommunities.org',
    theme.paragraph.font,
    bounds: Rect.fromLTWH(PdfLayoutSpec.pageNumBoxWidth, y, 0, 0),
  );

  document.template.bottom = footer;

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
