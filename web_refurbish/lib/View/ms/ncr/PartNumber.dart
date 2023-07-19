import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/ms/InputCustomizadoMs.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/service/PartService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:validadores/Validador.dart';

class PartNumber extends StatefulWidget {
  final Order order;

  const PartNumber({Key key, this.order}) : super(key: key);

  @override
  _PartNumberState createState() => _PartNumberState();
}

class _PartNumberState extends State<PartNumber> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Part part;
  String pn;
  bool isLoading = false;

  Future<bool> _getPartNumber(String pn) async {
    setState(() {
      this.isLoading = true;
    });
    part = await PartService.browseSip(pn);
    if (part != null) {
      return true;
    }
    return false;
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
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarCostumizada(
        title: "NCR - PartNumber",
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      floatingActionButton: this.isLoading
          ? SizedBox.shrink()
          : FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              mini: true,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  //processo para recuperar PN do microssiga
                  if (await _getPartNumber(this.pn)) {
                    setState(() {
                      this.isLoading = false;
                    });
                    Navigator.pushNamed(context, "/motivo",
                        arguments: {"os": widget.order, "pn": this.part});
                  } else {
                    _showSnackBar("Partnumber ${pn} não foi encontrado na base de dados!", "Não");

                    setState(() {
                      this.isLoading = false;
                    });
                  }
                }
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: SizedBox(
          width: _width / 2,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (this.isLoading)
                  CircularProgressIndicator(
                    backgroundColor: AppTheme.scaffoldBackgroundColor,
                  ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            // Navigator.pushReplacementNamed(context, "/gerarncr");
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      SizedBox(
                        width: 200,
                      ),
                      Expanded(
                        child: new LinearPercentIndicator(
                          // width: 140.0,
                          // lineHeight: 5.0,
                          percent: 0.4,
                          // center: Text(
                          //   "25.0%",
                          //   style: new TextStyle(fontSize: 12.0),
                          // ),
                          // trailing: Icon(Icons.mood),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.grey,
                          progressColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Qual é o PartNumber?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                //TextFormField(),
                InputCustomizadoMs(
                  controller: null,
                  hint: null,
                  maxLines: 1,
                  validador: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO,
                            msg: 'Obrigatório informar o PartNUmber')
                        .minLength(5, msg: 'mínimo de 5 caracteres')
                        // .maxLength(8,msg: 'valor máximo de 8 caracteres')
                        .validar(valor);
                  },
                  onSaved: (pn) {
                    this.pn = pn;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
