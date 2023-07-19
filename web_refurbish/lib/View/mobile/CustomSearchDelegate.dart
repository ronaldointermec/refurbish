import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refurbish_web/View/mobile/ShipmentCounter.dart';
import 'package:refurbish_web/builder/mobile/ShipmentBuilder.dart';
import 'package:refurbish_web/manager/mobile/ShipmentManager.dart';
import 'package:refurbish_web/model/Impressora.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/service/OrderService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/service/mobile/PrintService.dart';
import 'package:refurbish_web/service/mobile/ShipmentService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomSearchDelegate extends SearchDelegate<String> {
  Shipment order = Shipment();
  bool isDetails = true;
  String nomeCliente;
  Impressora impressora = Impressora();

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
          // focusColor: Colors.white,
          // hoverColor: Colors.white,
        ));
  }

//change hit text and keyboard type.
  CustomSearchDelegate({
    String hintText = "Pesquisar OS",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildSuggestions(BuildContext context) {
    ShipmentManager manager = context.fetch<ShipmentManager>();

    if (query.length == 0)
      manager.inFilter.add("");
    else
      manager.inFilter.add(query);

    return ShipmentBuilder(
      stream: manager.browse$,
      builder: (BuildContext context, shipmentList) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: shipmentList.length,
          itemBuilder: (BuildContext context, int index) {
            Shipment shipment = shipmentList[index];

            return Slidable(
              key: UniqueKey(),
              /*ObjectKey(shipment)*/
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Detalhe',
                  color: Colors.indigo,
                  icon: Icons.info,
                  onTap: () {
                    showResults(context);
                    order.os = shipment.os;
                    order.local = shipment.local;
                  },
                ),
                IconSlideAction(
                  closeOnTap: false,
                    caption: 'Imprimir',
                    color: Colors.red,
                    icon: Icons.print,
                    onTap: () async {
                      // if (await _validaImpressao(shipment.os, context)) {
                      //   _showSnackBar(context, "Imprimindo...", "Sim");
                      // }

                      if (!kIsWeb) {
                        if (PrintService.getIP() != null) {
                          List<Order> orderList =
                              await OrderService.browse(shipment.os);

                          print('from delegate:${orderList[0].customer_name}');

                          if (orderList.length > 0) {
                            order.os = shipment.os;
                            nomeCliente = orderList[0].customer_name;

                            if (await impressora.print(
                                customer: nomeCliente, order: shipment.os)) {
                              _showSnackBar(context, "Imprimindo...", "Sim");
                            } else {
                              _showSnackBar(context,
                                  "Erro ao conectar à impressora!", "Não");
                            }
                          } else {
                            _showSnackBar(
                                context, "Cliente não localizado!", "Não");
                          }
                        } else {
                          _showSnackBar(
                              context, "Configure um IP válído!", "Não");
                        }
                      } else {
                        _showSnackBar(context,
                            "Impressão disponível só para coletor!", "Não");
                      }
                    }),
                IconSlideAction(
                  caption: 'Arquivar',
                  color: Colors.blue,
                  icon: Icons.archive,
                  onTap: () async {
                    shipment.status_id = 3;
                    shipment.updated_by =
                        await UserService.getUserEidPreferentes();
                    if (await ShipmentService.update(shipment)) {
                      _showSnackBar(context, "Sucesso ao arquivar!", "Sim");
                      manager.inFilter.add("");
                    } else {
                      _showSnackBar(context, "Falha ao ao arquivar!", "Não");
                      manager.inFilter.add("");
                    }
                  },
                ),
                IconSlideAction(
                  caption: 'Voltar',
                  color: Colors.black45,
                  icon: Icons.arrow_back,
                  onTap: () {},
                ),
              ],
              child: ListTile(
                onTap: () {
                  // showResults(context);
                  // order.os = shipment.os;
                  // order.local = shipment.local;
                },
                title: Text(
                  shipment.os,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                subtitle: Text(
                  shipment.local,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  child: Icon(
                    Icons.mobile_friendly_outlined,
                    //color: Colors.black54,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 40,
                  color: Colors.black54,
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
          //color: Colors.white,
        ),
        onPressed: () {
          query = '';
        },
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ShipmentCounter(),
      )
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'OS\n',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                children: [
                  TextSpan(
                      text: order.os,
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                ]),
          ),
          Container(
            height: 20,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Local\n",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
              children: [
                TextSpan(
                    text: order.local,
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<bool> _validaImpressao(String os, context) async {
  //   if (!kIsWeb) {
  //     if (PrintService.getIP() != null) {
  //       List<Order> orderList = await OrderService.browse(os);
  //
  //       if (orderList.length > 0) {
  //         order.os = os;
  //         nomeCliente = orderList[0].customer_name;
  //
  //         if (await impressora.print(customer: nomeCliente, order: os)) {
  //           return true;
  //         } else {
  //           _showSnackBar(context, "Erro ao conectar à impressora!", "Não");
  //           return false;
  //         }
  //       } else {
  //         _showSnackBar(context, "Cliente não localizado!", "Não");
  //         return false;
  //       }
  //     } else {
  //       _showSnackBar(context, "Configure um IP válído!", "Não");
  //       return false;
  //     }
  //   } else {
  //     _showSnackBar(context, "Impressão disponível só para coletor!", "Não");
  //     return false;
  //   }
  // }

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
