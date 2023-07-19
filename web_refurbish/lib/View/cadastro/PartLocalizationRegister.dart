import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refurbish_web/View/criar/CriarPage.dart';
import 'package:refurbish_web/View/widgets/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/InputCustomizado.dart';
import 'package:refurbish_web/View/widgets/widgets.dart';
import 'package:refurbish_web/manager/ScannerManager.dart';
import 'package:refurbish_web/model/Part.dart';
import 'package:refurbish_web/model/PartLocalization.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/service/LocalizationService.dart';
import 'package:refurbish_web/service/PartLocalizationService.dart';
import 'package:refurbish_web/service/PartService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:validadores/Validador.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PartLocalizationRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Responsive(mobile: Mobile(), desktop: CriarPage());
}

class Mobile extends StatefulWidget {
  const Mobile({Key key}) : super(key: key);

  @override
  _MobileState createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  final _formKey = GlobalKey<FormState>();

  String _pn;
  String _address;
  int _qtd;
  bool _temPNCadastrado = false;
  bool _temLocalCadastrado = false;
  bool _usaScanner = false;
  ScannerManager scannerManager;
  TextEditingController _pnController = TextEditingController();
  TextEditingController _localController = TextEditingController();
  TextEditingController _qtdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      scannerManager = ScannerManager();
      _onDecode();
    }
  }

  // @override
  // void dispose() {
  //     super.dispose();
  //     scannerManager.dispose();
  // }

  _onDecode() {
    scannerManager.getCode.listen((code) async {
      if (code != null) {
        _usaScanner = true;
        if (!code.contains('REF')) {
          Part part = await PartService.browse(code);
          if (part != null) {
            setState(() {
              _temPNCadastrado = true;
              _pnController.text = code;
            });
          } else {
            setState(() {
              _temPNCadastrado = false;
            });
          }
        } else {
          Localization localization = await LocalizationService.browse(code);

          if (localization != null) {
            setState(() {
              _temLocalCadastrado = true;
              _localController.text = code;
            });
          } else {
            setState(() {
              _temLocalCadastrado = false;
            });
          }
        }
      }
    });
  }

  _alocacao(BuildContext context, PartLocalization partLocalization) async {
    int statusCod;
    if (_temPNCadastrado) {
      if (_temLocalCadastrado) {
        statusCod = await PartLocalizationService.save(partLocalization);
      } else {
        _showSnackBar("Cadastre o local antes de utilizá-lo!!", "Não");
      }
    } else {
      _showSnackBar("Cadastre o PN antes de utilizá-lo!!", "Não");
    }

    if (statusCod == 200) {
      _showSnackBar("Sucesso gerar alocação! ", "Sim");
      if (!_usaScanner) {
        Navigator.pop(context);
        _usaScanner = false;
      } else {
        _pnController.text = '';
        _localController.text = '';
        _qtdController.text = '';
        setState(() {
          _temPNCadastrado = false;
          _temLocalCadastrado = false;
        });
      }
    } else {
      _showSnackBar(
          "Falha ao gerar alocação!\n Verifique se o PN e o Local estão cadastrados!",
          "Não");
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
    return SingleChildScrollView(
      child: Form(
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
                      autofocus: Responsive.isMobile(context) ? false : true,
                      readOnly: Responsive.isMobile(context) ? true : false,
                      onFieldSubmitted: (String text) async {
                        if (text != null) {
                          // manager.inPn.add(text);
                          text = text.trim();
                          Part part = await PartService.browse(text);

                          if (part != null) {
                            setState(() {
                              _temPNCadastrado = true;
                            });
                          } else {
                            setState(() {});
                            _temPNCadastrado = false;
                          }
                        }
                      },
                      controller: _pnController,
                      hint: 'PN',
                      onSaved: (address) {
                        this._pn = address;
                      },
                      maxLines: null,
                      validador: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                                msg: "PartNumber obrigatório")
                            .minLength(4, msg: "Mínimo de 4 caractres")
                            .valido(valor);
                      },
                      icon: _temPNCadastrado
                          ? Icons.check
                          : Responsive.isDesktop(context)
                              ? Icons.search
                              : FontAwesomeIcons.barcode,
                      color: _temPNCadastrado ? Colors.green : Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, right: 32, left: 32),
                    child: InputCustomizado(
                        readOnly: Responsive.isMobile(context) ? true : false,
                        onFieldSubmitted: (String text) async {
                          if (text != null) {
                            text = text.trim();
                            Localization localization =
                                await LocalizationService.browse(text);

                            if (localization != null) {
                              setState(() {
                                _temLocalCadastrado = true;
                              });
                            } else {
                              setState(() {
                                _temLocalCadastrado = false;
                              });
                            }
                          }
                        },
                        controller: _localController,
                        hint: 'Local',
                        onSaved: (address) {
                          this._address = address;
                        },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Local obrigatório")
                              .minLength(4, msg: "Mínimo de 4 caractres")
                              .valido(valor);
                        },
                        icon: _temLocalCadastrado
                            ? Icons.check
                            : Responsive.isDesktop(context)
                                ? Icons.search
                                : FontAwesomeIcons.barcode,
                        color:
                            _temLocalCadastrado ? Colors.green : Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, right: 32, left: 32),
                    child: InputCustomizado(
                      autofocus: Responsive.isMobile(context) ? true : false,
                      keyboarType: TextInputType.number,
                      controller: _qtdController,
                      hint: 'QTD',
                      onSaved: (qtd) {
                        this._qtd = int.parse(qtd);
                      },
                      maxLines: 1,
                      validador: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                                msg: "Quantidade obrigatório")
                            //.minLength(4, msg: "Mínimo de 4 caractres")
                            .minVal(1, msg: 'Quantidade mínina: 1')
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
                          Part part = Part(this._pn, null);
                          Localization localization =
                              Localization(this._address);

                          PartLocalization partlocalization =
                              PartLocalization(null, part, localization);
                          partlocalization.qtd = this._qtd;
                          partlocalization.created_by =
                              await UserService.getUserEidPreferentes();

                          _alocacao(context, partlocalization);
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
