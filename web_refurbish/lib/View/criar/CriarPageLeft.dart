import 'package:flutter/material.dart';
import 'package:refurbish_web/model/PartLocalizationDataSourceLeft.dart';
import 'package:refurbish_web/View/widgets/TextFormFieldCustomizado.dart';
import 'package:refurbish_web/builder/PartLocalizationBuilder.dart';
import 'package:refurbish_web/manager/PartLocalizationManager.dart';
import 'package:refurbish_web/main.dart';

class CriarPageLeft extends StatefulWidget {
  const CriarPageLeft({Key key}) : super(key: key);

  @override
  _CriarPageLeftState createState() => _CriarPageLeftState();
}

class _CriarPageLeftState extends State<CriarPageLeft> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    PartLocalizationManager manager = context.fetch<PartLocalizationManager>();
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 16, right: 8, left: 16),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 500,
                        child: TextFormFieldCustomizado(
                          mensagemPesquisa: "Pesquisa por PN/Descrição",
                          onChange: (text) {
                            if (text.length > 2) {
                              manager.inFilter.add(text);
                            }
                          },
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // color: Colors.white,
                          ),
                          width: _width * 0.45,
                          child: PartLocalizationBuilder(
                            stream: manager.browse$,
                            builder: (context, partlocalizations) {
                              return partlocalizations.length > 0
                                  ? PaginatedDataTable(
                                      // columnSpacing: 10.0,
                                      // horizontalMargin: 10,
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
                                      columns: PartLocalizationDataSourceLeft
                                          .dataColumn,
                                      source: PartLocalizationDataSourceLeft(
                                          partlocalizations, context))
                                  : Center(
                                      child: Text(
                                        "Nada encontrado :(",
                                        style: TextStyle(
                                            fontSize: 32, color: Colors.white),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),

                      // PagarMenu(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
