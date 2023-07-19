import 'package:flutter/material.dart';
import 'package:refurbish_web/View/mobile/CustomizedInput.dart';
import 'package:refurbish_web/manager/ScannerManager.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/service/mobile/ShipmentService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:validadores/Validador.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Alocacao extends StatefulWidget {
  @override
  _AlocacaoState createState() => _AlocacaoState();
}

class _AlocacaoState extends State<Alocacao> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _osController = TextEditingController();
  TextEditingController _localController = TextEditingController();
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
    scanner.getCode.listen(
          (result) {
        setState(
              () {
            if (!result.contains('-') && !result.contains('\r')) {
              _osController.text = result;
              if (_localController.text.isNotEmpty) {
                _save();
              }
            } else {
              if (result.contains('-')) {
                shipment.is_lab = false;
                _localController.text = result;
                _save();
              } else {
                shipment.is_lab = true;
                result = result.replaceAll("\r", " :: ");
                _localController.text = result;
                _save();
              }
            }
          },
        );
      },
    );
  }
  ///antes de tratar o "/' 20220112
  // void _onDecode() {
  //   scanner.getCode.listen(
  //     (result) {
  //       setState(
  //         () {
  //           if (result.contains('/')) {
  //             _osController.text = result;
  //             if (_localController.text.isNotEmpty) {
  //               _save();
  //             }
  //           } else {
  //             if (result.contains('-')) {
  //               shipment.is_lab = false;
  //               _localController.text = result;
  //               _save();
  //             } else {
  //               shipment.is_lab = true;
  //               result = result.replaceAll("\r", " :: ");
  //               _localController.text = result;
  //               _save();
  //             }
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  _save() async {
    if (_osController.text.isNotEmpty && _localController.text.isNotEmpty) {
      if (_formkey.currentState.validate()) {
        _formkey.currentState.save();
        shipment.status_id = 2;
        shipment.created_by =
            await UserService.getUserEidPreferentes() ?? "NULL";

        int statusCode = await ShipmentService.save(shipment);

        if (statusCode == 200) {
          _osController.text = '';
          _localController.text = '';

          _showSnackBar(context,
              "ALOCADO\nOS: ${shipment.os} \nLOC: ${shipment.local}", "Sim");
        } else if (statusCode == 202) {
          _showSnackBar(
              context, "OS já alocada com os dados informados!", "Não");
        } else {
          _showSnackBar(context, "Erro ao alocar $statusCode", "Não");
        }
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
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Expedição - Alocar",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _osController.text = '';
                _localController.text = '';
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Card(
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
                      padding: EdgeInsets.only(
                          bottom: 15, right: 16, left: 16, top: 32),
                      child: CustomizedInput(
                        controller: _osController,
                        hint: 'OS',
                        readOnly: true,
                        onSaved: (os) {
                          shipment.os = os;
                        },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "OS mandatory")
                              .minLength(5, msg: "The minimum length is 5")
                              .valido(valor);
                        },
                        icon: Icons.input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 32, right: 16, left: 16),
                      child: CustomizedInput(
                        controller: _localController,
                        hint: 'LOCAL',
                        readOnly: true,
                        onSaved: (local) {
                          shipment.local = local;
                        },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Local mandatory")
                              .maxLength(10, msg: "The maximum length is 10")
                              .valido(valor);
                        },
                        icon: Icons.place,
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
