import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refurbish_web/View/mobile/DashBoard.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/InputCustomizado.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/builder/report/PosicaoEstoqueBuider.dart';
import 'package:refurbish_web/manager/report/PosicaoStoqueManager.dart';
import 'package:refurbish_web/model/report/PosicaoEstoque.dart';
import 'package:refurbish_web/model/report/PosicaoEstoqueSource.dart';
import 'package:refurbish_web/service/report/ExcelExport.dart';
import 'package:refurbish_web/main.dart';

class PosicaoDeEstoqueView extends StatelessWidget {
  PosicaoDeEstoqueView({Key key}) : super(key: key);

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
  List<PosicaoEstoque> estoque = [];
  DateTime _dateTime;
  TextEditingController _dateInicalController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  String _inicio;
  String _fim;

  @override
  Widget build(BuildContext context) {
    PosicaoStoqueManager manager = context.fetch<PosicaoStoqueManager>();

    return Scaffold(
      appBar: AppBarCostumizada(
        title: "Relatório - Posição de Estoque",
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
                child: Container(
                  width: 1200,
                  height: 600,
                  child: PosicaoEstoqueBuider(
                      stream: manager.browse$,
                      builder: (context, posicaoStoqueList) {
                        estoque = posicaoStoqueList;
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
                            columns: PosicaoEstoqueSource.dataColumn,
                            source: PosicaoEstoqueSource(posicaoStoqueList));
                      }),
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
                        if (estoque.length > 0)
                          ExcelExport.posicaoEstoque(
                              estoque,
                              _dateInicalController.text,
                              _dateEndController.text);
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
