import 'package:flutter/material.dart';
import 'package:refurbish_web/View/mobile/CustomizedInput.dart';
import 'package:refurbish_web/View/mobile/ShipmentCounterLab.dart';
import 'package:refurbish_web/manager/ScannerManager.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/service/mobile/ShipmentService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:validadores/Validador.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Remover extends StatefulWidget {
  @override
  _RemoverState createState() => _RemoverState();
}

class _RemoverState extends State<Remover> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _osController = TextEditingController();
  TextEditingController _localController = TextEditingController();
  TextEditingController _osController2 = TextEditingController();
  ScannerManager scanner;

  Shipment shipment;

  @override
  void initState() {
    super.initState();
    shipment = Shipment();
    if (!kIsWeb) {
      scanner = ScannerManager();
      _onDecode();
    }
  }


  void _onDecode() {
    scanner.getCode.listen((result) {
      setState(
            () {
          if (!result.contains('-') && !result.contains('\r')) {
            if (_osController.text.isEmpty || _localController.text.isEmpty) {
              _osController.text = result;
              _pesquisar();
            } else if (_localController.text.isNotEmpty) {
              _osController2.text = result;
            }
          }
        },
      );
    });
  }

  // void _onDecode() {
  //   scanner.getCode.listen((result) {
  //     setState(
  //       () {
  //         if (result.contains('/')) {
  //           if (_osController.text.isEmpty || _localController.text.isEmpty) {
  //             _osController.text = result;
  //             _pesquisar();
  //           } else if (_localController.text.isNotEmpty) {
  //             _osController2.text = result;
  //           }
  //         }
  //       },
  //     );
  //   });
  // }

  _pesquisar() async {
    if (_osController.text.isNotEmpty) {
      print( 'chegou aqui ${_osController.text}');
      shipment.os = _osController.text;
      List<Shipment> shipmentList = await ShipmentService.browseLab(shipment);

      if (shipmentList.length < 1) {
        _showSnackBar(
            context, 'OS ${_osController.text} não encontrada', 'Não');
        _osController.text = '';
      } else if (shipmentList[0].status_id == 3) {
        // shipment = shipmentList[0];

        _showSnackBar(
            context,
            'OS Já removida do carrinho!\nÚtima localização: ${shipmentList[0].local}',
            'Não');
        _osController.text = '';
        _localController.text = '';
      } else {
        List<String> split = shipmentList[0].local.split(" ");
        _localController.text = split[2] + " " + split[1] + " " + split[0];
        shipment = shipmentList[0];
      }
    }
  }

  _update() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      if (_osController.text == _osController2.text) {
        shipment.status_id = 3;
        shipment.updated_by = await UserService.getUserEidPreferentes();
        if (await ShipmentService.update(shipment)) {
          _showSnackBar(context, 'OS ${_osController.text} removida', 'Sim');

          _osController.text = '';
          _osController2.text = '';
          _localController.text = '';
        } else {
          _showSnackBar(
              context, 'Erro ao remover OS ${_osController.text}', 'Não');
        }
      } else {
        _showSnackBar(context, "As OSs  são diferentes", 'Não');
      }
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

  @override
  void dispose() {
    if (!kIsWeb) {
      scanner.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Lab - Remover",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ShipmentCounterLab(),
          ),
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _osController.text = '';
                _localController.text = '';
                _osController2.text = '';
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Card(
            // color: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16, left: 16, top: 32),
                      child: CustomizedInput(
                        keyboarType: TextInputType.datetime,
                        controller: _osController,
                        hint: 'OS',
                        readOnly: false,
                        onSaved: (os) {
                          shipment.os = os;
                        },
                        // onChanged: (text) {
                        //   if (text.length >= 2) {
                        //     text = text.replaceAll("/", "");
                        //     String os = text.substring(0, text.length - 2) +
                        //         "/" +
                        //         text.substring(text.length - 2, text.length);
                        //
                        //     _osController.text = os;
                        //     _osController.selection =
                        //         TextSelection.fromPosition(TextPosition(
                        //             offset: _osController.text.length));
                        //     os = '';
                        //   }
                        // },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "OS mandatory")
                              //.minLength(7, msg: "The minimum length is 7")
                              .valido(valor);
                        },
                        icon: Icons.input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: TextButton(
                        child: Text("PESQUISAR",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        onPressed: () {
                          _pesquisar();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 16, right: 16, left: 16, top: 16),
                      child: CustomizedInput(
                        fillColor: Colors.redAccent[80],
                        controller: _localController,
                        hint: 'LOCAL',
                        readOnly: true,
                        onSaved: (posicao) {
                          shipment.local = posicao;
                        },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Posição:: Altura mandatory")
                              // .maxLength(5, msg: "The maximum length is 5")
                              .valido(valor);
                        },
                        icon: Icons.place,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: CustomizedInput(
                        controller: _osController2,
                        keyboarType: TextInputType.datetime,
                        hint: 'OS',
                        readOnly: false,
                        // onChanged: (text) {
                        //   if (text.length >= 2) {
                        //     text = text.replaceAll("/", "");
                        //     String os = text.substring(0, text.length - 2) +
                        //         "/" +
                        //         text.substring(text.length - 2, text.length);
                        //
                        //     _osController2.text = os;
                        //     _osController2.selection =
                        //         TextSelection.fromPosition(TextPosition(
                        //             offset: _osController2.text.length));
                        //
                        //     os = '';
                        //   }
                        // },
                        onSaved: (altura) {
                          shipment.local = altura;
                        },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "OS de confirmação mandatory")
                              //.maxLength(5, msg: "The maximum length is 5")
                              .valido(valor);
                        },
                        icon: Icons.input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 32, left: 32, bottom: 16),
                      child: TextButton(
                        child: Text("REMOVER",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        onPressed: () {
                          _update();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
