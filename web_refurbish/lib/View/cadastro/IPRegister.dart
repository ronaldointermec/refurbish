import 'package:flutter/material.dart';
import 'package:refurbish_web/View/widgets/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/InputCustomizado.dart';
import 'package:refurbish_web/service/mobile/PrintService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:validadores/Validador.dart';

class IPRegister extends StatefulWidget {
  const IPRegister({Key key}) : super(key: key);

  @override
  _IPRegisterState createState() => _IPRegisterState();
}

class _IPRegisterState extends State<IPRegister> {
  final _formKey = GlobalKey<FormState>();

  String ipAddress;

  _cadastrarIP() async {


    if (await PrintService.setIP(ipAddress)) {
      _showSnackBar("Sucesso ao salvar IP Address! ", "Sim");
      Navigator.pop(context);
    } else {
      _showSnackBar("Falha ao salvar IP Address!", "Não");
    }
  }

  void _showSnackBar(String text, String ans) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
        content: Row(
          children: <Widget>[Text(text)],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        title: Text('Cadastro - IP'),
      ),
      body: Form(
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
                      keyboarType: TextInputType.number,
                      autofocus: true,
                      controller: null,
                      hint: 'IP Address',
                      onSaved: (reason) {
                        this.ipAddress = reason;
                      },
                      maxLines: null,
                      validador: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "IP obrigatório")
                            .minLength(10, msg: "Mínimo de 10 caractres")
                            .valido(valor);
                      },
                      icon: null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 32, bottom: 15, right: 32, left: 32),
                    child: BotaoCustomizado(
                      texto: 'SALVAR',
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          _cadastrarIP();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
