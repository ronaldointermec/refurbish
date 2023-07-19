import 'package:flutter/material.dart';
import 'package:refurbish_web/View/widgets/SnackBarCustomizada.dart';
import 'package:refurbish_web/model/Requisition.dart';
import 'package:refurbish_web/View/pagar/PagarItemMenu.dart';
import 'package:refurbish_web/builder/RequisitionBuilder.dart';
import 'package:refurbish_web/manager/RequisitionManager.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/service/OrderService.dart';
import 'package:refurbish_web/settings/Global.dart';

class PagarMenu extends StatefulWidget {
  @override
  _PagarMenuState createState() => _PagarMenuState();
}

class _PagarMenuState extends State<PagarMenu> {
  bool isSelected = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    RequisitionManager manager = context.fetch<RequisitionManager>();
    manager.inFilter.add('');
    return RequisitionBuilder(
      stream: manager.browse$,
      builder: (context, requisitions) {
        return  requisitions.length > 0 ? GridView.builder(
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

                // manager.inRequisiton.add(requisition);

                String status =
                await OrderService.getStatusOS(requisition.order.os);
                if (status != 'EM SEPARAÇÃO DE PEÇAS' &&
                    status != 'EM MONTAGEM' &&
                    status != 'EM REFURBISH' &&
                    status != 'RETRABALHO' &&
                    status != 'EM ANALISE') {

                  ScaffoldMessenger.of(context).showSnackBar(SnackBarCustomizada(
                      context,
                      scaffoldKey,
                      '$status: Não é possível encerrar requisição com este Status!',
                      'Não'));
                } else {
                  if (Global.isEmprestimo) {
                    manager.inEmprestimo.add(requisition);
                  } else {
                    manager.inRequisiton.add(requisition);
                  }
                }

              },
              child: PagarItemMenu(
                  isSelected: requisition.priority,
                  colors: [
                    // Colors.primaries[Random().nextInt(Colors.primaries.length)],
                    //Colors.primaries[Random().nextInt(Colors.primaries.length)]
                    index % 2 == 0 ? Color(0xFF04A777) : Color(0xFFED6A5A),
                    index % 2 == 0 ? Color(0xFF496DDB) : Color(0xFFA40E4C)
                  ],
                  projectName: requisition.order.os),
            );
          },
        ) : Center(
          child: Text(
            "Nada encontrado :(",
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        );
      },
    );
  }
}
