import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../../../data/models/product_modal.dart';

class ExportService {
  static Future<void> exportCsv(Product product) async {
    final rows = <List<dynamic>>[
      ['ID', 'Title', 'Description', 'In Stock', 'Date', 'Time', 'Image URL'],
      [
        product.id,
        product.title,
        product.description,
        product.isInStock ? 'Yes' : 'No',
        product.formattedDate,
        product.formattedTime,
        product.imageUrl,
      ],
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final filename = 'product_${product.id}.csv';

    if (kIsWeb) {
      final bytes = Uint8List.fromList(csv.codeUnits);
      final xfile = XFile.fromData(bytes, name: filename, mimeType: 'text/csv');
      await Share.shareXFiles([xfile], text: 'Product CSV report');
    } else {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$filename';
      final file = File(path);
      await file.writeAsString(csv);
      await Share.shareXFiles([XFile(path)], text: 'Product CSV report');
    }
  }

  static Future<void> exportPdf(Product product) async {
    final doc = pw.Document();
    pw.MemoryImage? productImage;

    try {
      if (product.imageUrl.isNotEmpty) {
        final resp = await http.get(Uri.parse(product.imageUrl));
        if (resp.statusCode == 200) {
          productImage = pw.MemoryImage(resp.bodyBytes);
        }
      }
    } catch (_) {}

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Product Report',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 8),
            pw.Text('Generated on ${DateTime.now()}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.Divider(),
            if (productImage != null) ...[
              pw.Center(
                child: pw.Container(
                  height: 180,
                  width: double.infinity,
                  child: pw.Image(productImage, fit: pw.BoxFit.cover),
                ),
              ),
              pw.SizedBox(height: 16),
            ],
            _row('ID', product.id),
            _row('Title', product.title),
            _row('Description', product.description),
            _row('Stock', product.isInStock ? 'In Stock' : 'Out of Stock'),
            _row('Date', product.formattedDate),
            _row('Time', product.formattedTime),
            _row('Image URL', product.imageUrl),
          ],
        ),
      ),
    );

    final bytes = await doc.save();
    final filename = 'product_${product.id}.pdf';

    if (kIsWeb) {
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } else {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$filename';
      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      await Share.shareXFiles([XFile(path)], text: 'Product PDF report');
    }
  }

  static pw.Widget _row(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text('$label:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }
}
