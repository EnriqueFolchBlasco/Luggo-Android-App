import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as el_pdf;
import 'package:printing/printing.dart';

// no borrar
//https://www.youtube.com/watch?v=vdRCbg2FQ2M el scan QR + pdf
//https://pub.dev/packages/printing
//https://pub.dev/packages/pdf
//https://stackoverflow.com/questions/61920331/how-can-i-generate-qr-code-and-show-it-on-a-pdf-page-in-flutter




Future<void> generarEtiquetasPdf(List<Map<String, String>> mobles) async {
  final pdf = el_pdf.Document();

  pdf.addPage(
    el_pdf.MultiPage(
      build: (context) => [
        el_pdf.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: mobles.map((moble) {
            return el_pdf.Container(
              width: 200,
              height: 100,
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
                      el_pdf.Text('Nom de ítem: ${moble['itemName']}', style: el_pdf.TextStyle(fontSize: 10)),
                      el_pdf.Text('Mudanza: ${moble['mudanzaName']}', style: el_pdf.TextStyle(fontSize: 10)),
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
