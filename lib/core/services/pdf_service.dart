// ════════════════════════════════════════════════════════════════
// FILE: lib/core/services/pdf_service.dart
// Earnings PDF report generation (pdf: ^3.10.8).
// ════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../models/earning_model.dart';
import '../models/user_model.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

/// Generates a downloadable earnings summary PDF for a period.
class PdfService {
  PdfService._();

  /// Builds the PDF document bytes.
  static Future<File> generateEarningsReport({
    required UserModel user,
    required List<EarningModel> earnings,
    required String periodLabel,
    required double total,
  }) async {
    final pdf = pw.Document();
    final primary = PdfColor.fromInt(0xFF6C63FF);
    final accent = PdfColor.fromInt(0xFF06B6D4);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('PARTIX',
                      style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: primary)),
                  pw.Text(periodLabel,
                      style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text('Earnings Report',
                  style: pw.TextStyle(fontSize: 16, color: accent)),
              pw.Divider(thickness: 1.5, color: primary),
              pw.SizedBox(height: 12),
              pw.Text('Member: ${user.fullName} (${user.memberId})',
                  style: const pw.TextStyle(fontSize: 12)),
              pw.Text('Rank: ${user.rank}  |  Team: ${user.totalTeamSize}',
                  style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 16),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF1F1F6),
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TOTAL EARNED',
                        style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(CurrencyFormatter.format(total),
                        style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: primary)),
                    pw.Text(
                        'From ${earnings.length} transactions',
                        style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Transaction Details',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _earningsTable(earnings),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                  'Generated on ${DateFormatter.medium(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'partix_earnings_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _earningsTable(List<EarningModel> earnings) {
    final rows = earnings.take(50).map((e) {
      return pw.TableRow(
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(e.typeLabel,
                  style: const pw.TextStyle(fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(e.fromUserName,
                  style: const pw.TextStyle(fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(DateFormatter.medium(e.date),
                  style: const pw.TextStyle(fontSize: 9))),
          pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(CurrencyFormatter.format(e.amount),
                  style: const pw.TextStyle(fontSize: 9))),
        ],
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColor.fromInt(0xFFE2E2EE)),
      children: [
        pw.TableRow(
          decoration:
              pw.BoxDecoration(color: PdfColor.fromInt(0xFF6C63FF)),
          children: [
            _header('Type'),
            _header('From'),
            _header('Date'),
            _header('Amount'),
          ],
        ),
        ...rows,
      ],
    );
  }

  static pw.Widget _header(String text) => pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text,
          style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFFFFFFFF))));

  /// Saves the PDF and opens it via the OS viewer.
  static Future<void> generateAndOpen({
    required UserModel user,
    required List<EarningModel> earnings,
    required String periodLabel,
    required double total,
  }) async {
    final file = await generateEarningsReport(
      user: user,
      earnings: earnings,
      periodLabel: periodLabel,
      total: total,
    );
    await OpenFile.open(file.path);
  }
}
