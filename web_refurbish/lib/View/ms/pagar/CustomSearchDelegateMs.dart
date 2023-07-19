import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:refurbish_web/View/widgets/ms/BotaoCustomizado.dart';
import 'package:refurbish_web/builder/ms/RequisitionBuilderMs.dart';
import 'package:refurbish_web/manager/ms/RequisitionManagerMs.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/model/ms/RequisitionMs.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/service/ms/RequisitionServiceMs.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:pdf/pdf.dart';

class CustomSearchDelegateMs extends SearchDelegate<String> {
  //change SearchDelegate color
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: AppTheme.scaffoldBackgroundColor,
        primaryIconTheme: IconThemeData(color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
          fillColor: Colors.white,
        ));
  }

//change hit text and keyboard type.
  CustomSearchDelegateMs({
    String hintText = "Pesquisar OS",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildSuggestions(BuildContext context) {
    RequisitionManagerMs manager = context.fetch<RequisitionManagerMs>();

    if (query.length == 0)
      manager.inFilter.add("");
    else
      manager.inFilter.add(query);

    return RequisitionBuilderMs(
      stream: manager.browse$,
      builder: (BuildContext context, requisitionMsList) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: requisitionMsList.length,
          itemBuilder: (BuildContext context, int index) {
            RequisitionMs requisition = requisitionMsList[index];

            return ListTile(
              title: Text(
                requisition.order.os,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                    text: "\n",
                    style: TextStyle(fontSize: 14),
                    children: [
                      /**********************************/
                      TextSpan(
                          text: "Partnumber\n", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: requisition.pn + "\n",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      TextSpan(text: "\n", style: TextStyle(fontSize: 14)),
                      /**********************************/
                      TextSpan(text: "Local\n", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: requisition.position + "\n",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      TextSpan(text: "\n", style: TextStyle(fontSize: 14)),
                      /**********************************/
                      TextSpan(text: "Status\n", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: requisition.status.message,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))
                    ]),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue[700],
                child: Icon(
                  Icons.mobile_friendly_outlined,
                ),
              ),
              trailing: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [getButton(requisition, manager, context)],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.close,
          ),
        onPressed: () {
          query = '';
        },
      ),
      // Padding(
      //   padding: const EdgeInsets.only(right: 8.0),
      //   child: ShipmentCounter(),
      // )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
  }

  Widget getButton(RequisitionMs requisition, RequisitionManagerMs manager,
      BuildContext context) {
    switch (requisition.statusId) {
      case 1:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: BotaoCustomizado(
                texto: "Aprovar",
                backgroundColor: Colors.amber,
                onPressed: () async {
                  requisition.updated_by =
                      await UserService.getUserEidPreferentes();
                  requisition.statusId = 2;
                  if (await NcrService.update(requisition)) {
                    manager.inFilter.add("");
                    _showSnackBar(context, "Sucesso na aprovação!", "Sim");
                  } else {
                    _showSnackBar(context, "Erro na aprovação!", "Não");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: BotaoCustomizado(
                texto: "Imprimir",
                backgroundColor: Colors.red,
                onPressed: () async {
                  List<PartLocalization> partLocalizations = [];
                  partLocalizations.add(PartLocalization(
                      null,
                      Part(requisition.pn, requisition.description),
                      Localization(requisition.position)));

                  Requisition req = Requisition(
                      requisition_number: requisition.id,
                      priority: false,
                      partLocalizations: partLocalizations,
                      order: requisition.order);

                  if (req != null) {
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat pageFormat) async =>
                            req.buildPdf(pageFormat));
                  }
                },
              ),
            )
          ],
        );
        break;
      case 2:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: BotaoCustomizado(
                texto: "Utilizar",
                backgroundColor: Colors.blue,
                onPressed: () async {
                  requisition.updated_by =
                      await UserService.getUserEidPreferentes();
                  requisition.statusId = 3;
                  if (await NcrService.update(requisition)) {
                    manager.inFilter.add("");
                    _showSnackBar(context, "Sucesso na utilização!", "Sim");
                  } else {
                    _showSnackBar(context, "Erro na utilização!", "Não");
                  }
                  ;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: BotaoCustomizado(
                texto: "Devolver",
                backgroundColor: Colors.green,
                onPressed: () async {
                  requisition.updated_by =
                      await UserService.getUserEidPreferentes();
                  requisition.statusId = 4;
                  if (await NcrService.update(requisition)) {
                    manager.inFilter.add("");
                    _showSnackBar(context, "Sucesso na devolução!", "Sim");
                  } else {
                    _showSnackBar(context, "Erro na devolução!", "Não");
                  }
                  ;
                },
              ),
            ),
          ],
        );

        break;
      case 3:
        return Padding(
          padding: EdgeInsets.only(right: 8),
          child: BotaoCustomizado(
            texto: "Finalizar",
            backgroundColor: Colors.indigo,
            onPressed: () async {
              requisition.updated_by =
                  await UserService.getUserEidPreferentes();
              requisition.statusId = 5;
              if (await NcrService.update(requisition)) {
                manager.inFilter.add("");
                _showSnackBar(context, "Sucesso na finalização!", "Sim");
              } else {
                _showSnackBar(context, "Erro na finalização!", "Não");
              }
            },
          ),
        );
      case 4:
        return Padding(
          padding: EdgeInsets.only(right: 8),
          child: BotaoCustomizado(
            texto: "Finalizar",
            backgroundColor: Colors.indigo,
            onPressed: () async {
              requisition.updated_by =
                  await UserService.getUserEidPreferentes();
              requisition.statusId = 5;
              if (await NcrService.update(requisition)) {
                manager.inFilter.add("");
                _showSnackBar(context, "Sucesso na finalização!", "Sim");
              } else {
                _showSnackBar(context, "Erro na finalização!", "Não");
              }
            },
          ),
        );
        break;
    }
  }

  void _showSnackBar(BuildContext context, String text, String ans) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
        content: Row(
          children: <Widget>[Text(text)],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
