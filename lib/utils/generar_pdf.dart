import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/services/shared_prefs_service.dart';
import 'package:luggo/utils/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as el_pdf;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

// no borrar
//https://www.youtube.com/watch?v=vdRCbg2FQ2M el scan QR + pdf
//https://pub.dev/packages/printing
//https://pub.dev/packages/pdf
//https://stackoverflow.com/questions/61920331/how-can-i-generate-qr-code-and-show-it-on-a-pdf-page-in-flutter
//https://stackoverflow.com/questions/67466037/how-to-attach-images-jpg-png-etc-from-assets-into-a-pdf   / l ode rootBundle



Future<void> generarEtiquetasPdf(List<Map<String, String>> mobles) async {
  final pdf = el_pdf.Document();
  final ByteData imageData = await rootBundle.load('assets/images/LuggoColor_noBackground.png');
  final el_pdf.ImageProvider logoImage = el_pdf.MemoryImage(imageData.buffer.asUint8List());
  final String? email = await SharedPrefsService().getEmail();

  final String itemLabel = 'nomItem'.tr();
  final String mudanzaLabel = 'mudanzaName'.tr();

  pdf.addPage(
    el_pdf.MultiPage(
      build: (context) => [
        el_pdf.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: mobles.map((moble) {
            return el_pdf.Container(
              width: 235,
              height: 80,
              padding: const el_pdf.EdgeInsets.all(8),
              decoration: el_pdf.BoxDecoration(
                border: el_pdf.Border.all(),
              ),


              child: el_pdf.Row(
                children: [
                  //*********************************************************
                  // !!! generador del QR dins dle pdf !!! 110525
                  // idMudanza:idItem
                  el_pdf.BarcodeWidget(
                    data: '${moble['mudanzaId']}:${moble['itemId']}',
                    barcode: el_pdf.Barcode.qrCode(),
                    width: 60,
                    height: 60,
                  ),
                  //*********************************************************
                  el_pdf.SizedBox(width: 10),

                  el_pdf.Column(
                    crossAxisAlignment: el_pdf.CrossAxisAlignment.start,
                    children: [
                      el_pdf.SizedBox(height: 2),

                      el_pdf.Image(logoImage, width: 80, height: 80),

                      el_pdf.SizedBox(height: 2),
                      
                      el_pdf.Row(
                        children: [
                          el_pdf.Text(itemLabel, style: el_pdf.TextStyle(fontSize: 10)),
                          el_pdf.Text(moble['itemName'].toString(), style: el_pdf.TextStyle(fontSize: 10, color: PdfColor.fromInt(AppColors.primaryColor.value)),),
                        ]
                      ),
                      el_pdf.SizedBox(height: 2),

                      el_pdf.Row(
                        children: [
                          el_pdf.Text(mudanzaLabel, style: el_pdf.TextStyle(fontSize: 10)),
                          el_pdf.Text(moble['mudanzaName'].toString(), style: el_pdf.TextStyle(fontSize: 10, color: PdfColor.fromInt(AppColors.primaryColor.value)),),
                        ]
                      ),
                      el_pdf.SizedBox(height: 2),

                      el_pdf.Text(email ?? 'Error', style: el_pdf.TextStyle(fontSize: 10))
                      
                      

                    ],
                  ),

                ],
              ),



            );
          }).toList(),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );

}
