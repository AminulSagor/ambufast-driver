import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'trip_details_controller.dart';

extension TripDetailsPDF on TripDetailsController {
  Future<void> downloadReceipt() async {
    final pdf = pw.Document();

    // === FONTS ===
    final roboto =
    pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final robotoBold =
    pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));

    // === IMAGES ===
    final logo =
    pw.MemoryImage((await rootBundle.load('assets/pdf/logo.png')).buffer.asUint8List());
    final googlePlay = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/google_play.png')).buffer.asUint8List());
    final appStore = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/app_store.png')).buffer.asUint8List());
    final social = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/social_media.png')).buffer.asUint8List());
    final banner = pw.MemoryImage(
        (await rootBundle.load('assets/support_page_image.png')).buffer.asUint8List());

    // === COLORS ===
    final red = PdfColor.fromHex('#E24636');
    final grey = PdfColor.fromHex('#F5F5F5');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
            pw.Container(
            height: 170,
            width: double.infinity,
            child: pw.Stack(
              children: [
                // === RED BACKGROUND WITH SMOOTH RIGHT DIAGONAL CUT ===
                pw.CustomPaint(
                  size: const PdfPoint(595, 170),
                  painter: (context, size) {
                    context
                      ..setFillColor(red)
                      ..moveTo(0, size.y) // bottom-left
                      ..lineTo(size.x, size.y) // bottom-right
                      ..lineTo(size.x, 45) // top-right offset for smooth cut
                      ..lineTo(size.x * 0.82, 0) // diagonal cut down
                      ..lineTo(0, 0) // top-left
                      ..closePath()
                      ..fillPath();
                  },
                ),

                // === HEADER CONTENT ===
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // ===== FIRST ROW: LOGO + EMAIL =====
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Image(logo, width: 160),
                          pw.Text(
                            'care@ambufast.com',
                            style: pw.TextStyle(
                              font: roboto,
                              color: PdfColors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      //pw.SizedBox(height: 10),

                      // ===== SECOND ROW: MESSAGE + DETAILS =====
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Left side: thank-you message
                          pw.Container(
                            width: 310,
                            child: pw.Text(
                              'We hope you and your loved ones are safe and recovering well. '
                                  'Thank you for trusting AmbuFast during your time of need.',
                              style: pw.TextStyle(
                                font: roboto,
                                color: PdfColors.white,
                                fontSize: 13,
                                lineSpacing: 1.4,
                              ),
                            ),
                          ),

                          // Right side: trip/order details
                          pw.Container(
                            width: 210,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(
                                  'Created: ${DateFormat('yyyy-MMM-dd hh:mm a').format(DateTime.now())}',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 12),
                                ),
                                pw.Text(
                                  'Journey Date: ${DateFormat('yyyy-MMM-dd hh:mm a').format(tripTime.value)}',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 12),
                                ),
                                pw.Text(
                                  'Order Status: Completed',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 12),
                                ),
                                pw.Text(
                                  'Payment Status: ${finalPay.value.isPaid ? 'Paid' : 'Unpaid'}',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===== TRIP DETAILS =====
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(24, 20, 24, 10),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'TRIP DETAILS',
                          style: pw.TextStyle(
                            font: robotoBold,
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                        ),
                        //pw.SizedBox(height: 8),
                        pw.Container(
                          width: PdfPageFormat.a4.width, // full page width ensures proper layout
                          padding: const pw.EdgeInsets.only(right: 55), // ✅ add right-side padding
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // === LEFT SIDE: Ambulance + Distance ===
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    ambulance.value,
                                    style: pw.TextStyle(
                                      font: robotoBold,
                                      fontSize: 11,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.Text(
                                    '${distanceKm.value.toStringAsFixed(2)} kilometres, ${etaMins.value} minutes',
                                    style: pw.TextStyle(font: roboto, fontSize: 10),
                                  ),
                                ],
                              ),

                              // === RIGHT SIDE: License Plate ===
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    'LICENSE PLATE:',
                                    style: pw.TextStyle(
                                      font: robotoBold,
                                      fontSize: 10,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.Text(
                                    vehicleLine.value.isNotEmpty
                                        ? vehicleLine.value
                                        : 'DHM-HA-73-3316',
                                    style: pw.TextStyle(font: roboto, fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        pw.Container(
                          margin: const pw.EdgeInsets.symmetric(vertical: 8),
                          height: 0.5,
                          width: PdfPageFormat.a4.width-55,
                          color: PdfColors.grey400,
                        ),

                        pw.SizedBox(height: 12),

                        // === PICKUP + DROP CONNECTED MARKER ===
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // === LEFT SIDE: ICONS & LINE ===
                            pw.Column(
                              children: [
                                // Pickup circle
                                pw.Container(
                                  width: 10,
                                  height: 10,
                                  decoration: pw.BoxDecoration(
                                    color: red,
                                    shape: pw.BoxShape.circle,
                                  ),
                                ),

                                // Connecting line
                                pw.Container(
                                  width: 2,
                                  height: 40, // adjust as needed for spacing
                                  color: red,
                                ),

                                // Drop square
                                pw.Container(
                                  width: 10,
                                  height: 10,
                                  decoration: pw.BoxDecoration(
                                    color: red,
                                    shape: pw.BoxShape.rectangle,
                                  ),
                                  child: pw.Center(
                                    child: pw.Container(
                                      width: 4,
                                      height: 4,
                                      color: PdfColors.white, // inner white square for style
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            pw.SizedBox(width: 8),

                            // === RIGHT SIDE: TEXT DETAILS ===
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                // Pickup details
                                pw.Text(
                                  DateFormat('hh:mm a').format(
                                    tripTime.value.subtract(
                                      Duration(minutes: etaMins.value ~/ 2),
                                    ),
                                  ),
                                  style: pw.TextStyle(font: roboto, fontSize: 10),
                                ),
                                pw.Text(
                                  pickup.value,
                                  style: pw.TextStyle(font: roboto, fontSize: 10),
                                ),

                                pw.SizedBox(height: 20), // aligns drop text with bottom icon

                                // Drop details
                                pw.Text(
                                  DateFormat('hh:mm a').format(
                                    tripTime.value.add(
                                      Duration(minutes: etaMins.value),
                                    ),
                                  ),
                                  style: pw.TextStyle(font: roboto, fontSize: 10),
                                ),
                                pw.Text(
                                  drop.value,
                                  style: pw.TextStyle(font: roboto, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),


                  ],
                ),
              ),

              // ===== FARE SECTION =====
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(24, 10, 24, 20),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Table(
                        columnWidths: {
                          0: const pw.FlexColumnWidth(2),
                          1: const pw.FlexColumnWidth(1),
                        },
                        border: pw.TableBorder.all(width: 0),
                        children: [
                          _fareRow('Base Fare', 'BDT 60.00', roboto, robotoBold),
                          _fareRow('Additional Service', 'BDT 0.00', roboto, robotoBold),
                          _fareRow('+ Per KM rate', 'BDT 60.00', roboto, robotoBold),
                          _fareRow('+ Waiting Charges', 'BDT 0.00', roboto, robotoBold),
                          _fareRow('Arrival cost', 'BDT 0.00', roboto, robotoBold),
                          _fareRow('Booking fee', 'BDT 0.00', roboto, robotoBold),
                          _fareRow('Discount', 'BDT 0.00', roboto, robotoBold),
                          _fareRow('Total', 'BDT 120.00', roboto, robotoBold, bold: true),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        color: grey,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _paymentRow('Confirmation Payment', 'BDT 60.00', roboto),
                            _paymentRow('Completion Payment', 'BDT 60.00', roboto),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== TOTAL =====
              pw.Padding(
                padding: const pw.EdgeInsets.only(right: 24, bottom: 12),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      'BDT 120.00',
                      style: pw.TextStyle(
                        font: robotoBold,
                        fontSize: 14,
                        color: PdfColors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== FOOTER =====
              // ===== SMALL FOOTER =====
              pw.Container(
                color: red,
                padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    // === TOP ROW ===
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        // --- LEFT SIDE ---
                        pw.Expanded(
                          flex: 2,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'AmbuFast.com',
                                style: pw.TextStyle(
                                  font: robotoBold,
                                  color: PdfColors.white,
                                  fontSize: 10,
                                ),
                              ),
                              pw.SizedBox(height: 2),
                              pw.Text(
                                'An Initiative of SafeCare 24/7 Medical Services Limited.\n'
                                    'Plot 16, Road 13, Sector 4, Uttara, Dhaka 1230 Bangladesh.',
                                style: pw.TextStyle(
                                  font: roboto,
                                  color: PdfColors.white,
                                  fontSize: 8,
                                  lineSpacing: 1.1,
                                ),
                              ),
                              pw.SizedBox(height: 2),
                              pw.Text('Email: care@ambufast.com',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 8)),
                              pw.Text('Phone: 09678911911',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 8)),
                            ],
                          ),
                        ),

                        // --- RIGHT SIDE ---
                        pw.Expanded(
                          flex: 2,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                'BILLED TO',
                                style: pw.TextStyle(
                                  font: robotoBold,
                                  color: PdfColors.white,
                                  fontSize: 9,
                                ),
                              ),
                              pw.SizedBox(height: 1),
                              pw.Text(driverName.value,
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 8)),
                              pw.Text('Email: kamrul@domain.com',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 7)),
                              pw.Text('Phone: 09678911911',
                                  style: pw.TextStyle(font: roboto, color: PdfColors.white, fontSize: 7)),
                              pw.SizedBox(height: 4),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Image(googlePlay, width: 55),
                                  pw.SizedBox(width: 6),
                                  pw.Image(appStore, width: 55),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 5),

                    // === SOCIAL MEDIA ICONS CENTERED ===
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Image(social, width: 90),
                      ],
                    ),

                    pw.SizedBox(height: 10),

                    // === BANNER INSIDE FOOTER ===
                    pw.Image(
                      banner,
                      width: PdfPageFormat.a4.width - 48, // respect padding (24 * 2)
                      fit: pw.BoxFit.cover,
                    ),

                    // === SMALL RED AREA AFTER BANNER ===
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),


            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory(); // or getDownloadsDirectory() if available
    final file = File('${dir.path}/AmbuFast_Receipt_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);


    await OpenFilex.open(file.path);

  }
}

// === HELPERS ===
pw.TableRow _fareRow(
    String label,
    String value,
    pw.Font roboto,
    pw.Font robotoBold, {
      bool bold = false,
    }) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          label,
          style: pw.TextStyle(
            font: bold ? robotoBold : roboto,
            fontSize: 10,
          ),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(
            font: bold ? robotoBold : roboto,
            fontSize: 10,
          ),
        ),
      ),
    ],
  );
}

pw.Widget _paymentRow(String label, String value, pw.Font roboto) => pw.Padding(
  padding: const pw.EdgeInsets.symmetric(vertical: 2),
  child: pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(label, style: pw.TextStyle(font: roboto, fontSize: 10)),
      pw.Text(value, style: pw.TextStyle(font: roboto, fontSize: 10)),
    ],
  ),
);
