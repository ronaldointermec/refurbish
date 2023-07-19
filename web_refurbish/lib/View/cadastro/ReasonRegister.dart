import 'package:flutter/material.dart';
import 'package:refurbish_web/View/widgets/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/InputCustomizado.dart';
import 'package:refurbish_web/model/Reason.dart';
import 'package:refurbish_web/service/ReasonService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:validadores/Validador.dart';

class ReasonRegister extends StatefulWidget {
  const ReasonRegister({Key key}) : super(key: key);

  @override
  _ReasonRegisterState createState() => _ReasonRegisterState();
}

class _ReasonRegisterState extends State<ReasonRegister> {
  final _formKey = GlobalKey<FormState>();

  String description;

  _cadastrarMotivo(BuildContext context, Reason reason) async {
    int statusCod = await ReasonService.save(reason);

    if (statusCod == 200) {
      _showSnackBar("Sucesso ao salvar Motivo! ", "Sim");
      Navigator.pop(context);
    } else {
      _showSnackBar("Falha ao salvar Motivo!", "Não");
    }
  }

  void _showSnackBar(String text, String ans) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
        content: Row(
          children: <Widget>[
            // Icon(
            //   ans.compareTo("Sim") == 0 ? Icons.favorite : Icons.watch_later,
            //   color: ans.compareTo("Sim") == 0 ? Colors.pink : Colors.yellow,
            //   size: 24.0,
            //   semanticLabel: text,
            // ),
            Text(text)
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, right: 32, left: 32),
                  child: InputCustomizado(
                    autofocus: true,
                    controller: null,
                    hint: 'Motivo',
                    onSaved: (reason) {
                      this.description = reason;
                    },
                    maxLines: null,
                    validador: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Motivo obrigatório")
                          .minLength(10, msg: "Mínimo de 10 caractres")
                          .valido(valor);
                    },
                    icon: null,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 32, bottom: 15, right: 32, left: 32),
                  child: BotaoCustomizado(
                    texto: 'SALVAR',
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Reason reason = Reason(
                            description.toUpperCase(),
                            await UserService.getUserEidPreferentes(),
                            null,
                            null);

                        _cadastrarMotivo(context, reason);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
