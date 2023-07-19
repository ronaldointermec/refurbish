import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:refurbish_web/View/widgets/AlertDialogCustomizado.dart';
import 'package:refurbish_web/builder/RequisitionItemBuider.dart';
import 'package:refurbish_web/manager/RequisitionManager.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:get/get.dart';
import 'package:refurbish_web/service/RequisitionService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:refurbish_web/main.dart';
import 'package:pdf/pdf.dart';
import 'package:refurbish_web/model/Requisition.dart';

class PagarPageRightRequisicao extends StatefulWidget {
  //const PagarPageRightRequisicao({Key key}) : super(key: key);
  @override
  _PagarPageRightRequisicaoState createState() =>
      _PagarPageRightRequisicaoState();
}

class _PagarPageRightRequisicaoState extends State<PagarPageRightRequisicao> {
  Requisition requisition;

  Requisition req = Get.put(Requisition());

  void _encerrarReuisicao(context, manager) {
    if (requisition != null && !req.isEmprestimo.value) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialogCustomizado(
            title: 'CONFIRMAÇÃO',
            widget: Text(
                'Deseja finalizar requisição ${requisition.requisition_number}?'),
            onPressedSim: () async {
              Navigator.pop(context, 'Sim');
              requisition.updated_by =
                  await UserService.getUserEidPreferentes();
              int codStatus = await RequisitionService.close(requisition);

              if (codStatus == 200) {
                _showSnackBar(
                    "Sucesso ao finalizar requisição! ", "Sim", context);
                manager.inFilter.add('');
                requisition = null;
                manager.inRequisiton.add(requisition);
              } else {
                _showSnackBar(
                    "Falha ao finalizar requisição! ", "Não", context);
              }
            },
            childSim: 'Sim',
            onPressedNao: () {
              Navigator.pop(context, 'Não');
            },
            childNao: 'Não',
          );
        },
      );
    } else {
      _showSnackBar("Selecione um item! ", "Não", context);
    }
  }

  void _showSnackBar(String text, String ans, context) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
        content: Row(
          children: <Widget>[
            // Icon(
            //   ans.compareTo("Sim") == 0 ? Icons.favorite : Icons.watch_later,
            //   color: ans.compareTo("Sim") == 0 ? Colors.pink : Colors.yellow,
            //   size: 24.0,
            //   semanticLabel: text,
            // ),
            Text(text)
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    RequisitionManager manager = context.fetch<RequisitionManager>();

    // manager.inFilter.add('');
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Encerra requisição',
          onPressed: () async {
            _encerrarReuisicao(context, manager);
          },
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
          mini: true,
          elevation: 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
              child: RequisitionItemBuider(
                stream: manager.requisition$,
                builder: (context, req) {
                  requisition = req;

                  return Center(
                    child: //Text(dataSnapshot.data.order.os)
                        PdfPreview(
                      //maxPageWidth: 600,
                      // build: (format) => _generatePdf(format),
                      build: (PdfPageFormat pageFormat) =>
                          requisition.buildPdf(pageFormat),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
