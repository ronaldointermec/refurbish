import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:refurbish_web/View/widgets/ms/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/ms/InputCustomizadoMs.dart';
import 'package:refurbish_web/builder/ms/NcrBuilder.dart';
import 'package:refurbish_web/manager/ms/NcrManager.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/main.dart';
import 'package:refurbish_web/model/ms/Ncr.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/service/ms/NcrService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:pdf/pdf.dart';
import 'package:validadores/Validador.dart';

class CustomSearchDelegateNcr extends SearchDelegate<String> {
  //change SearchDelegate color
  String movimentacao;
  Ncr ncrObject;
  NcrManager manager;
  final _formKey = GlobalKey<FormState>();

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
  CustomSearchDelegateNcr({
    String hintText = "Pesquisar OS",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildSuggestions(BuildContext context) {
    manager = context.fetch<NcrManager>();

    if (query.length == 0)
      manager.inFilter.add("");
    else
      manager.inFilter.add(query);

    return NcrBuilder(
      stream: manager.browse$,
      builder: (BuildContext context, ncrList) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.grey[200],
          ),
          itemCount: ncrList.length,
          itemBuilder: (BuildContext context, int index) {
            Ncr ncr = ncrList[index];

            return ListTile(
              title: Text(
                ncr.order.os,
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
                      /*****************************/
                      TextSpan(
                          text: "PartNumber\n", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: ncr.pn + "\n",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      /*****************************/
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(text: "Local\n", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: ncr.position + "\n",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      /*****************************/
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                          text: "Quantidade\n", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: ncr.quantidade.toString() + "\n",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      /*****************************/
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(text: "Tipo\n", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: ncr.tipo + "\n",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      /*****************************/
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
                  children: [getButton(ncr, manager, context)],
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
    double _width = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: _width / 2,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Qual o número da movimentação do Microsiga?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                child: InputCustomizadoMs(
                  controller: null,
                  hint: null,
                  maxLines: 1,
                  validador: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO,
                            msg:
                                'Obrigatório informar o número da movimentação')
                        .minLength(5, msg: 'mínimo de 5 caracteres')
                        // .maxLength(8,msg: 'valor máximo de 8 caracteres')
                        .validar(valor);
                  },
                  onSaved: (movimentacao) {
                    this.movimentacao = movimentacao;
                  },
                ),
              ),
              Container(
                height: 50,
                child: BotaoCustomizado(

                  texto: "Salvar",
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      ncrObject.mov_microsiga = movimentacao;

                      if (await NcrService.update(ncrObject)) {
                        manager.inFilter.add("");
                        Navigator.pop(context);
                        _showSnackBar(context, "Sucesso ao salvar!", "Sim");
                      } else {
                        _showSnackBar(context, "Erro na aprovação!", "Não");
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getButton(Ncr ncr, NcrManager manager, BuildContext context) {
    switch (ncr.status_id) {
      case 1:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: BotaoCustomizado(
                texto: "Aprovar",
                backgroundColor: Colors.amber,
                onPressed: () async {
                  showResults(context);
                  ncr.updated_by = await UserService.getUserEidPreferentes();
                  ncr.status_id = 3;
                  ncrObject = ncr;
                  // if (await NcrService.update(ncr)) {
                  //   manager.inFilter.add("");
                  //   _showSnackBar(context, "Sucesso na aprovação!", "Sim");
                  // } else {
                  //   _showSnackBar(context, "Erro na aprovação!", "Não");
                  // }
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
                  partLocalizations.add(PartLocalization(null,
                      Part(ncr.pn, ncr.desc_pn), Localization(ncr.position)));

                  Requisition req = Requisition(
                      requisition_number: ncr.id,
                      priority: false,
                      partLocalizations: partLocalizations,
                      order: ncr.order);

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
