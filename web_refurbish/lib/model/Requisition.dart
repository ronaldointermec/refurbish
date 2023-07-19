import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:refurbish_web/model/Order.dart';
import 'package:refurbish_web/model/PartLocalization.dart';
import 'package:get/get.dart';

class Requisition extends GetxController {
  List<PartLocalization> partLocalizations;
  int requisition_number;
  Order order;
  bool priority;
  String _updated_by;
  String _local;
  RxBool isEmprestimo = false.obs;

  void toggle() => isEmprestimo.value = isEmprestimo.value ? false : true;

  String get local => _local;

  set local(String value) {
    _local = value;
  }

  String get updated_by => _updated_by;

  set updated_by(String value) {
    _updated_by = value;
  }

  Requisition({
    this.requisition_number,
    this.priority,
    this.partLocalizations,
    this.order,
  });

  Requisition.fromJson(Map<String, dynamic> json) {
    this.requisition_number = json['id'];
    this.priority = json['priority'];
    this.order = Order.fromJson(json['order']);
    List<PartLocalization> pl = [];
    Iterable list = json['partlocalizations'];
    pl = list.map((json) => PartLocalization.fromJson(json)).toList();
    this.partLocalizations = pl;
  }

  Map<String, dynamic> toJson() => {
        "id": requisition_number,
        "updated_by": updated_by,
        "partlocalizations": partLocalizations,
      };

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.legal,
        maxPages: 20,
        margin: pw.EdgeInsets.only(right: 0, left: 0, top: 40),
        mainAxisAlignment: pw.MainAxisAlignment.start,
        header: _buildHeader,
        build: (context) => [
          pw.SizedBox(height: 20),

          //_partStorage(context),
          _contentTable(context)
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Center(
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Container(
                        height: 40,
                        //padding: const pw.EdgeInsets.only(left: 20),
                        alignment: pw.Alignment.center,
                        child: pw.Text('REQUISIÇÃO -  CONSULTA',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 20)),
                      ),
                      //pw.SizedBox(height: 20),
                      pw.Container(
                        height: 50,
                        width: 260,
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.pdf417(),
                          data: order.os,
                          drawText: true,
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        height: 180,
                        child: pw.DefaultTextStyle(
                          style: pw.TextStyle(
                            //color: _accentTextColor,s
                            fontSize: 20,
                          ),
                          child: pw.GridView(
                            crossAxisCount: 1,
                            children: [
                              pw.Row(children: [
                                pw.Text('REQUISIÇÃO: ',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Text(requisition_number.toString()),
                              ]),
                              pw.Row(children: [
                                pw.Text('ATEMDIMENTO: ',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Text(order.os),
                                pw.SizedBox(height: 2),
                              ]),
                              pw.Row(children: [
                                pw.Text('CONTRATO: ',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Text(order.contract_type),
                              ]),
                              pw.Row(children: [
                                pw.Text('CLIENTE: ',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Text(order.customer_name, maxLines: 1),
                              ]),
                              pw.Row(children: [
                                pw.Text('EQUIPAMENTO: ',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Text(order.part_number),
                              ]),
                              pw.Row(children: [
                                pw.Text('SERIALNUMBER: ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(order.serial_number),
                              ]),
                              pw.Row(children: [
                                pw.Text('DIAS: ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(order.days)
                              ]),
                              pw.Row(children: [
                                pw.Text('LOCAL: ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(local ?? "INDISPONÍVEL")
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'PN',
      'LOCAL',
      'DESC',
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: PdfColors.black),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
      },
      cellPadding: pw.EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 20,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.black,
        fontSize: 20,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.black,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        partLocalizations.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => partLocalizations[row].getIndex(col),
        ),
      ),
    );
  }

// pw.Widget _partStorage(pw.Context context) {
//   return pw.ListView.builder(
//       itemCount: partLocalizations.length,
//       itemBuilder: (context, index) {
//         PartLocalization partLocalization = partLocalizations[index];
//         return pw.Column(children: [
//           pw.Divider(),
//
//           pw.Column(children: [
//             pw.Row(children: [
//               pw.Text('PN:',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//               pw.Text(partLocalization.part.pn),
//               pw.SizedBox(width: 20),
//               pw.Text('LOCAL: ',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//               pw.Text(partLocalization.localization.address),
//               pw.SizedBox(width: 20),
//               pw.Text('QTD: ',
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//               pw.Text('1'),
//             ]),
//             pw.Row(children: [
//               // pw.Text('DESC: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//               pw.Text(partLocalization.part.description, maxLines: 2)
//             ])
//           ]),
//
//           // pw.Divider(height: 1, color: _darkColor),
//           // pw.SizedBox(height: 10),
//           //
//           // pw.Row(children: [
//           //   pw.Text('PN: ',
//           //       style: pw.TextStyle(
//           //           fontWeight: pw.FontWeight.bold, fontSize: 24)),
//           //   pw.Text(partLocalization.part.pn,
//           //       style: pw.TextStyle(fontSize: 24))
//           // ]),
//           // pw.SizedBox(height: 1),
//           // pw.Row(children: [
//           //   pw.Text('DESC: ',
//           //       style: pw.TextStyle(
//           //           fontWeight: pw.FontWeight.bold, fontSize: 24)),
//           //   pw.Text(partLocalization.part.description,
//           //       style: pw.TextStyle(fontSize: 24), maxLines: 2)
//           // ]),
//           // pw.SizedBox(height: 1),
//           // pw.Row(children: [
//           //   pw.Text('LOCAL: ',
//           //       style: pw.TextStyle(
//           //           fontWeight: pw.FontWeight.bold, fontSize: 24)),
//           //   pw.Text(partLocalization.localization.address,
//           //       style: pw.TextStyle(fontSize: 24))
//           // ]),
//           // pw.SizedBox(height: 1),
//           // pw.Row(children: [
//           //   pw.Text('QTD: ',
//           //       style: pw.TextStyle(
//           //           fontWeight: pw.FontWeight.bold, fontSize: 24)),
//           //   pw.Text('1', style: pw.TextStyle(fontSize: 24))
//           // ]),
//           // pw.SizedBox(height: 24),
//           //pw.Divider(height: 1,color: _darkColor)
//
//           if (context.pageNumber > 1) pw.SizedBox(height: 20)
//         ]);
//       });
// }
}
