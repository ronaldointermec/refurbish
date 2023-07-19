import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refurbish_web/View/mobile/DashBoard.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/InputCustomizado.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/builder/report/PecaSolicitadaEntregueBuilder.dart';
import 'package:refurbish_web/manager/report/PecaSolicitadaEntregueManager.dart';
import 'package:refurbish_web/model/report/PecaSolicitadaEntregue.dart';
import 'package:refurbish_web/model/report/PecaSolicitadaEntregueResource.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/service/report/ExcelExport.dart';


class PecaSolicitadaEntregueView extends StatelessWidget {
  PecaSolicitadaEntregueView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: DashBoard(), desktop: DeskTop());
  }
}

class DeskTop extends StatefulWidget {
  const DeskTop({Key key}) : super(key: key);

  @override
  _DeskTopState createState() => _DeskTopState();
}

class _DeskTopState extends State<DeskTop> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  List<PecaSolicitadaEntregue> requisicoes = [];
  DateTime _dateTime;
  TextEditingController _dateInicalController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  String _inicio;
  String _fim;

  @override
  Widget build(BuildContext context) {
    PecaSolicitadaEntregueManager manager =
        context.fetch<PecaSolicitadaEntregueManager>();

    return Scaffold(
      appBar: AppBarCostumizada(
        title: "Relatório - Peças Solicitadas x Entregues",
      ),
      drawer: AppDrawer(),
      //apaga aqui
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 1200,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32, left: 16),
                        child: InputCustomizado(
                          readOnly: true,
                          controller: _dateInicalController,
                          hint: 'Data Inicio',
                          icon: Icons.date_range,
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate:
                                  _dateTime == null ? DateTime.now() : _dateTime,
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2031),
                            ).then((date) {
                              setState(() {
                                _dateTime = date;
                                _inicio = _dateTime.toIso8601String();

                                _dateInicalController.text =
                                    "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}";
                              });
                            });
                          },
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32, right: 16),
                        child: InputCustomizado(
                          readOnly: true,
                          controller: _dateEndController,
                          hint: 'Data Fim',
                          icon: Icons.date_range,
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate:
                                  _dateTime == null ? DateTime.now() : _dateTime,
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2031),
                            ).then((date) {
                              setState(() {
                                _dateTime = date;

                                _fim = _dateTime.toIso8601String();

                                _dateEndController.text =
                                    "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}";
                              });
                            });
                          },
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, left: 16),
                    child: IconButton(
                        onPressed: () {
                          if (_dateInicalController.text.isNotEmpty &&
                              _dateEndController.text.isNotEmpty) {
                            Map<String, String> body = {
                              "inicialDate": _inicio,
                              "endDate": _fim
                            };

                            manager.inFilter.add(body);
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    //width: 1200,
                    height: 600,
                    child: PecaSolicitadaEntregueBuilder(
                        stream: manager.browse$,
                        builder: (context, pecaSolicitadaEntregueList) {
                          requisicoes = pecaSolicitadaEntregueList;

                          return PaginatedDataTable(
                              showCheckboxColumn: false,
                              showFirstLastButtons: true,
                              header: Text('ESTOQUE'),
                              rowsPerPage: _rowsPerPage,
                              availableRowsPerPage: <int>[8],
                              onRowsPerPageChanged: (int value) {
                                setState(() {
                                  _rowsPerPage = value;
                                });
                              },
                              columns: PecaSolicitadaEntregueResource.dataColumn,
                              source: PecaSolicitadaEntregueResource(
                                  pecaSolicitadaEntregueList));
                        }),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 1200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: BotaoCustomizado(
                      texto: "Excel",
                      onPressed: () {
                        if (requisicoes.length > 0) {
                          ExcelExport.pecaSolicitadaEntrega(
                              requisicoes,
                              _dateInicalController.text,
                              _dateEndController.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
