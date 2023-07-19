import 'package:flutter/material.dart';
import 'package:refurbish_web/builder/ms/PartNumberMicrossigaBuilder.dart';
import 'package:refurbish_web/manager/ms/PartNumberMicrosigaManager.dart';
import 'package:refurbish_web/model/ms/PartLocalizationDataSourceLeftMs.dart';
import 'package:refurbish_web/View/widgets/TextFormFieldCustomizado.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/model/export.dart';

class CriarPageLeftMs extends StatefulWidget {
  const CriarPageLeftMs({Key key}) : super(key: key);

  @override
  _CriarPageLeftMsState createState() => _CriarPageLeftMsState();
}

class _CriarPageLeftMsState extends State<CriarPageLeftMs> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    // PartLocalizationManager manager = context.fetch<PartLocalizationManager>();
    double _width = MediaQuery.of(context).size.width;

    PartNumberMicrosigaManager manager =
        context.fetch<PartNumberMicrosigaManager>();
    // manager1.inFilter.add('715-521-001');

    // manager.browse$.listen((partNumberMicrosigaList) {
    //   partNumberMicrosigaList.forEach((partNumberMicrosiga) => print(partNumberMicrosiga.position));
    // });
    //

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
                          mensagemPesquisa: "Consulta PN Microsiga",
                          onFieldSubmitted: (text) {
                            if (text.length > 5) {
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
                          child: PartNumberMicrossigaBuilder(
                            stream: manager.browse$,
                            builder: (context, partNumberMicrosigaList) {
                              int quantidade = 1;

                              List<PartLocalization> partlocalizations = [];

                              partNumberMicrosigaList
                                  .forEach((partNumberMicrosiga) {
                                Localization localization =
                                    Localization(partNumberMicrosiga.position);
                                Part part = Part(partNumberMicrosiga.name,
                                    partNumberMicrosiga.description);
                                PartLocalization partlocalization =
                                    PartLocalization(null, part, localization);

                                while (quantidade <=
                                    partNumberMicrosiga.quantity) {
                                  partlocalizations.add(partlocalization);
                                  quantidade += 1;
                                }
                              });

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
                                      source: PartLocalizationDataSourceLeftMs(
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
