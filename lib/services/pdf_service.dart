import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateFeesReceipt({
    required String studentName,
    required String className,
    required int amount,
    required String receiptNo,
    required String lang, // en / ar
    required Uint8List logoBytes, // YOUR EXACT LOGO
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (c) => pw.Column(
          children: [
            pw.Text("بسم الله الرحمن الرحيم", style: pw.TextStyle(fontSize: 16)),
            pw.Image(pw.MemoryImage(logoBytes), height: 80),
            pw.Text(lang=='ar' ? "إيصال دفع الرسوم" : "SALAAMA FEES RECEIPT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
            pw.Divider(),
            pw.Text("Receipt No: $receiptNo"),
            pw.Text("Name: $studentName"),
            pw.Text("Class: $className"),
            pw.Text("Amount: UGX $amount"),
            pw.Text("Date: ${DateTime.now()}"),
            pw.Spacer(),
            pw.Text("DESTINED TO SUCCEED", style: pw.TextStyle(color: PdfColors.blue)),
            pw.Text("Bursar Signature: __________"),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
    await Printing.sharePdf(bytes: await pdf.save(), filename: "Fees_$receiptNo.pdf");
  }

  // Same for Salary Receipt, Report Card, Hifz Certificate ممتاز (Arabic), Circular
  static Future<void> generateHifzCertificate({required String student, required int juz, required String level}) async {
    // Arabic certificate with ممتاز stamp + your exact logo + بسم الله
  }
}