import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/model/Order.dart';
import 'package:refurbish_web/View/widgets/TextFormFieldCustomizado.dart';
import 'package:refurbish_web/builder/OrderBuilder.dart';
import 'package:refurbish_web/manager/OrderManager.dart';
import 'package:refurbish_web/main.dart';

class CriarHeaderRight extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<bool> onChanged;

  //final bool value;

  const CriarHeaderRight({Key key, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderManager manager = context.fetch<OrderManager>();
    double _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: 500,
          child: TextFormFieldCustomizado(
            // textColor: Colors.black,
            // fillColor: Colors.white70,
            controller: this.controller,
            mensagemPesquisa: "Pesquisa OS",
            onFieldSubmitted: (text) async {
              if (text.isNotEmpty && text != null) {
                manager.inFilter.add(text);
              }
            },
            // onChange: (text) {
            //   if (text.length >= 2) {
            //     text = text.replaceAll("/", "");
            //     String os = text.substring(0, text.length - 2) +
            //         "/" +
            //         text.substring(text.length - 2, text.length);
            //
            //     controller.text = os;
            //     controller.selection = TextSelection.fromPosition(
            //         TextPosition(offset: controller.text.length));
            //
            //     os = '';
            //   }
            // },
          ),
        ),
        SizedBox(
          height: 30,
        ),
        SingleChildScrollView(
          child: OrderBuilder(
            stream: manager.browse$,
            builder: (context, orders) {
              return orders.length > 0
                  ? Container(
                      width: _width * 0.447,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      height: 140,
                      child: ListView.builder(
                        itemCount: orders.length, //orders.length,
                        itemBuilder: (context, index) {
                          Order order = orders[0];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "ATENDIMENTO: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      order.os,
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "CONTRATO: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      order.contract_type ?? " ",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "CLIENTE: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      order.customer_name ?? " ",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "EQUIPAMENTO: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      order.part_number ?? " ",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "SERIALNUMBER: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      order.serial_number ?? " ",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "STATUS: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      order.status ?? " ",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "DIAS: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      order.days ?? " ",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                // Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        "Nada encontrado :(",
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
