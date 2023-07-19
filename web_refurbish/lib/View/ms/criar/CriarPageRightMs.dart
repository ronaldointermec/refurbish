import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/View/criar/CriarHeaderRight.dart';
import 'package:refurbish_web/builder/PLBuilder.dart';
import 'package:refurbish_web/manager/OrderManager.dart';
import 'package:refurbish_web/manager/PartLocalizationManager.dart';
import 'package:refurbish_web/manager/ms/RequisitionManagerMs.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/model/ms/ItemStorageMs.dart';
import 'package:refurbish_web/model/ms/StorageMs.dart';
import 'package:refurbish_web/service/ms/RequisitionServiceMs.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:refurbish_web/main.dart';

class CriarPageRightMs extends StatefulWidget {
  const CriarPageRightMs({Key key}) : super(key: key);

  @override
  _CriarPageRightMsState createState() => _CriarPageRightMsState();
}

class _CriarPageRightMsState extends State<CriarPageRightMs> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  List<PartLocalization> partLocalizations;
  List<Order> orders;
  bool isNew = true;
  bool isPriority = false;
  bool isLoan = false;
  TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    partLocalizations = [];
    orders = [];
  }

  _criarRequisicao(context, orderManager, manager, managerMS) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirma criar requisição?'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Sim');
                  Global.podeAdicionarPN = false;
                  List<ItemStorageMs> itemSorages = [];

                  partLocalizations.forEach((partLocalization) {
                    ItemStorageMs item = ItemStorageMs(
                      pn: partLocalization.part.pn,
                      address: partLocalization.localization.address,
                      description: partLocalization.part.description,
                    );

                    itemSorages.add(item);
                  });

                  StorageMs storage = StorageMs(
                      order: orders[0],
                      item: itemSorages[0],
                      created_by: await UserService.getUserEidPreferentes() ??
                          "default",
                      status_id: 1,
                  );
                  int codStatus = await NcrService.create(storage);

                  if (codStatus == 200) {
                    managerMS.beep.sink.add("");
                    _showSnackBar("Sucesso ao criar requisição! ", "Sim");
                    setState(() {
                      orderManager.inFilter.add(null);
                      manager.inPartLocalization.add(null);
                      managerMS.inFilter.add("");
                      partLocalizations.clear();
                      orders.clear();
                      _controller.text = "";
                    });
                  } else {
                    _showSnackBar("Falha ao gerar requisição! ", "Não");
                  }
                },
                child: Text("Salvar")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Não');
                },
                child: Text("Cancelar"))
          ],
        );
      },
    );
  }

  void _showSnackBar(String text, String ans) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
        content: Row(
          children: <Widget>[Text(text)],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    PartLocalizationManager manager = context.fetch<PartLocalizationManager>();
    RequisitionManagerMs managerMS = context.fetch<RequisitionManagerMs>();
    OrderManager orderManager = context.fetch<OrderManager>();
    double _width = MediaQuery.of(context).size.width;

    orderManager.browse$.listen((order) {
      this.orders = order;
    });

    return Scaffold(
      // key: scaffoldKey,
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (orders.length < 1) {
            _showSnackBar('Nenhuma OS foi selecionada!', 'Não');
          }
          else if (orders[0].status != 'EM ANALISE' &&
              orders[0].status != 'RETRABALHO') {
            _showSnackBar(
                '${orders[0].status}: Não é possível gerar requisição com este Status!',
                'Não');
          }
          else if (partLocalizations.length == 0) {
            _showSnackBar('Nenhum partnumber foi selecionado!', 'Não');
          } else {
            _criarRequisicao(
                /*scaffoldKey.currentContext*/
                context,
                orderManager,
                manager,
                managerMS);
          }
        },
        mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 16),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      CriarHeaderRight(
                        controller: this._controller,
                      ),
                      Container(
                        //height: 500,
                        width: _width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppTheme.scaffoldBackgroundColor),
                        child: PLBuilder(
                            stream: manager.partLocalization$,
                            builder: (context, partLocalization) {
                              if (!Global.podeAdicionarPN) {
                                //mantem somente um pn na lista
                                partLocalizations.clear();
                                partLocalizations.add(partLocalization);
                                Global.podeAdicionarPN = true;
                              }

                              return PaginatedDataTable(
                                  showCheckboxColumn: false,
                                  showFirstLastButtons: true,
                                  header: Text('UTILIZAR'),
                                  rowsPerPage: _rowsPerPage,
                                  availableRowsPerPage: <int>[8],
                                  onRowsPerPageChanged: (int value) {
                                    setState(() {
                                      _rowsPerPage = value;
                                    });
                                  },
                                  columns: PartLocalizationDataSourceRight
                                      .dataColumn,
                                  source: PartLocalizationDataSourceRight(
                                      partLocalizations, manager));
                            }),
                      ),
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
