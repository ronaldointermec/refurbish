import 'package:flutter/material.dart';
import 'package:refurbish_web/View/reimpressao/ReimprimirMenu.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/TextFormFieldCustomizado.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/manager/report/PrintManager.dart';

class Reimprimir extends StatelessWidget {
  //const Reimprimir({Key? key}) : super(key: key);
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PrintManager manager = context.fetch<PrintManager>();
    double _width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBarCostumizada(
        title: 'Reimpressão - Requisição',
        exibeMenu: false,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Row(
          children: [
            Container(
              width: _width * 0.25,
            ),
            Container(
              width: _width * 0.5,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: 600,
                    child: TextFormFieldCustomizado(
                      controller: _controller,
                      mensagemPesquisa: "Pesquisa OS",
                      onChange: (text) {
                        if (text.isNotEmpty && text.length > 2) {

                          manager.inFilter.add(text);
                        }
                        else {
                          manager.inFilter.add(null);
                        };
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(width: 600, child: ReimprimirMenu())
                ],
              ),
            ),
            Container(
              width: _width * 0.25,
            ),
          ],
        ),
      ),
    );
  }
}
