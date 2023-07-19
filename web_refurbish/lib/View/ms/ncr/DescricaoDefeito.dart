import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/ms/InputCustomizadoMs.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:validadores/Validador.dart';

class DescricaoDefeito extends StatefulWidget {
  final Map osPNMotivo;

  const DescricaoDefeito({Key key, this.osPNMotivo}) : super(key: key);

  @override
  _DescricaoDefeitoState createState() => _DescricaoDefeitoState();
}

class _DescricaoDefeitoState extends State<DescricaoDefeito> {
  final _formKey = GlobalKey<FormState>();
  String desc;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBarCostumizada(
        title: "NCR - Descrição do defeito",
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        mini: true,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            if (this.desc != null) {
              Navigator.pushNamed(context, "/resumo", arguments: {
                "os": widget.osPNMotivo['os'],
                "pn": widget.osPNMotivo['pn'],
                "motivo": widget.osPNMotivo['motivo'],
                "desc": this.desc
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
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
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
                          percent: 0.8,
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
                  'Insira a descrição do defeito',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                //TextFormField(),
                InputCustomizadoMs(
                  controller: null,
                  hint: null,
                  maxLines: 2,
                  validador: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO,
                            msg: 'Obrigatório informar a descrição do defeito')
                        .minLength(20, msg: 'mínimo de 20 caracteres')
                        // .maxLength(8,msg: 'valor máximo de 8 caracteres')
                        .validar(valor);
                  },
                  onSaved: (desc) {
                    this.desc = desc;
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
