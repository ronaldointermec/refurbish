import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/View/criar/CriarHeaderRight.dart';
import 'package:refurbish_web/builder/PLBuilder.dart';
import 'package:refurbish_web/manager/OrderManager.dart';
import 'package:refurbish_web/manager/PartLocalizationManager.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/service/OrderService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:refurbish_web/main.dart';

class CriarPageRight extends StatefulWidget {
  const CriarPageRight({Key key}) : super(key: key);

  @override
  _CriarPageRightState createState() => _CriarPageRightState();
}

class _CriarPageRightState extends State<CriarPageRight> {
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

  _criarRequisicao(context, orderManager, manager) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirma criar requisição?'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                    title: Text('Conector'),
                    secondary: Icon(
                      Icons.adjust,
                      color: Colors.blue,
                    ),
                    value: isPriority,
                    onChanged: (bool value) {
                      stateSetter(() {
                        isPriority = value;
                      });
                    }),
                CheckboxListTile(
                    title: Text('Empréstimo'),
                    secondary: Icon(
                      Icons.add_shopping_cart_sharp,
                      color: Colors.blue,
                    ),
                    value: isLoan,
                    onChanged: (bool value) {
                      stateSetter(() {
                        isLoan = value;
                      });
                    }),
              ],
            );
          }),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Sim');
                  Global.podeAdicionarPN = false;
                  List<ItemStorage> itemSorages = [];

                  partLocalizations.forEach((partLocalization) {
                    ItemStorage item = ItemStorage(
                      part_id: partLocalization.part.id,
                      reason_id: partLocalization.reason_id,
                      address: partLocalization.localization.address,
                      part_localization_id: "",
                    );

                    itemSorages.add(item);
                  });

                  Storage storage = Storage(
                      order: orders[0],
                      storages: itemSorages,
                      priority: isPriority ? 1 : 0,
                      status_id: isLoan ? 4 : 2,
                      created_by: await UserService.getUserEidPreferentes() ??
                          "default");
                  int codStatus = await OrderService.create(storage);

                  if (codStatus == 200) {
                    _showSnackBar("Sucesso ao criar requisição! ", "Sim");
                    setState(() {
                      orderManager.inFilter.add(null);

                      manager.inPartLocalization.add(null);

                      partLocalizations.clear();
                      orders.clear();
                      _controller.text = "";
                    });
                  } else {
                    _showSnackBar(
                        "Falha ao gerar requisição! ",
                        "Não");
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
            // _showSnackBar('Nenhuma OS foi selecionada!', 'Não');
          }
          else if (
          orders[0].status != 'EM ANALISE' &&
              orders[0].status != 'EM SEPARAÇÃO DE PEÇAS' &&
              orders[0].status != 'EM MONTAGEM' &&
              orders[0].status != 'EM REFURBISH' &&
              orders[0].status != 'RETRABALHO') {
            _showSnackBar(
                '${orders[0].status}: Não é possível gerar requisição com este Status!',
                'Não');
          }
          else if (partLocalizations.length == 0) {
            _showSnackBar('Nenhum partnumber foi selecionado!', 'Não');
            print(orders[0].status);
          } else {
            _criarRequisicao(
              /*scaffoldKey.currentContext*/
                context,
                orderManager,
                manager);
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
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(8),
                //   color: Colors.white,
                // ),
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
