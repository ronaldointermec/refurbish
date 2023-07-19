import 'package:flutter/material.dart';
import 'package:refurbish_web/View/pagar/PagarMenu.dart';
import 'package:refurbish_web/View/pagar/PagarHeader.dart';
import 'package:refurbish_web/manager/RequisitionManager.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/manager/ms/NcrManager.dart';
import 'package:refurbish_web/manager/ms/RequisitionManagerMs.dart';
import 'package:refurbish_web/settings/Global.dart';

class PagarPageLeft extends StatefulWidget {
  const PagarPageLeft({Key key}) : super(key: key);

  @override
  _PagarPageLeftState createState() => _PagarPageLeftState();
}

class _PagarPageLeftState extends State<PagarPageLeft> {


  @override
  void initState() {
    super.initState();
    Global.podeConsultarRequisicao = true;
  }

  @override
  void dispose() {
    super.dispose();
    Global.podeConsultarRequisicao = false;
  }

  @override
  Widget build(BuildContext context) {

    RequisitionManager manager = context.fetch<RequisitionManager>();
    manager.loadRequisitionAutomatically("");

    RequisitionManagerMs managerMs = context.fetch<RequisitionManagerMs>();
    managerMs.loadRequisitionAutomatically("");

    NcrManager managerNcr = context.fetch<NcrManager>();
    managerNcr.loadNcrAutomatically("");

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            children: [

              PagarHeader(
                mensagemPesquisa: 'Pesquisa OS',
                onChange: (text) {
                  manager.inFilter.add(text);
                },
              ),

              // SizedBox(
              //   height: 15,
              // ),

              PagarMenu(),
            ],
          ),
        ),
      ),
    );
  }
}
