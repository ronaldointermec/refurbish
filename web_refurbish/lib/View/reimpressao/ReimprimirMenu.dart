import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:refurbish_web/manager/report/PrintManager.dart';
import 'package:refurbish_web/model/Requisition.dart';
import 'package:refurbish_web/View/pagar/PagarItemMenu.dart';
import 'package:refurbish_web/builder/RequisitionBuilder.dart';
import 'package:refurbish_web/main.dart';
import 'package:pdf/pdf.dart';

class ReimprimirMenu extends StatefulWidget {
  @override
  _ReimprimirMenuState createState() => _ReimprimirMenuState();
}

class _ReimprimirMenuState extends State<ReimprimirMenu> {
  bool isSelected = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PrintManager manager = context.fetch<PrintManager>();
    //manager.inFilter.add('');
    return RequisitionBuilder(
      stream: manager.browse$,
      builder: (context, requisitions) {
        return
          requisitions.length > 0
            ?
          GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: requisitions.length,
                itemBuilder: (context, index) {
                  Requisition requisition = requisitions[index];

                  return GestureDetector(
                    onTap: () async {
                      if (requisition != null) {
                        await Printing.layoutPdf(
                            onLayout: (PdfPageFormat pageFormat) async =>
                                requisition.buildPdf(pageFormat));
                      }
                    },
                    child: PagarItemMenu(
                        isSelected: requisition.priority,
                        colors: [
                          // Colors.primaries[Random().nextInt(Colors.primaries.length)],
                          //Colors.primaries[Random().nextInt(Colors.primaries.length)]
                          index % 2 == 0
                              ? Color(0xFF04A777)
                              : Color(0xFFED6A5A),
                          index % 2 == 0 ? Color(0xFF496DDB) : Color(0xFFA40E4C)
                        ],
                        projectName: requisition.order.os),
                  );
                },
              )
            : Center(
                child: Text(
                  "Nada encontrado :(",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              );

      },
    );
  }
}
