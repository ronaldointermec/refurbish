import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refurbish_web/View/criar/CriarPage.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/manager/ScannerManager.dart';
import 'package:refurbish_web/model/Part.dart';
import 'package:refurbish_web/View/widgets/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/InputCustomizado.dart';
import 'package:refurbish_web/service/PartService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:validadores/Validador.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PartRegister extends StatelessWidget {
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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pnController = TextEditingController();
  String pn;
  String desc;
  bool temPNCadastradonoSip = false;
  bool _usaScanner = false;
  ScannerManager scannerManager;

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
  //   super.dispose();
  //   scannerManager.dispose();
  // }
  _onDecode() {
    scannerManager.getCode.listen((code) async {
      if (code != null) {
        _usaScanner = true;

        Part part = await PartService.browseSip(code);

        if (part != null) {
          setState(() {
            temPNCadastradonoSip = true;
            _pnController.text = code;
            _descriptionController.text = part.description;
          });
        } else {
          setState(() {
            //temPNCadastradonoSip = false;
            if (!code.contains("REF")) {
              _pnController.text = code;
            }
            _descriptionController.text = '';
          });
        }
      }
    });
  }

  _cadastrarPN(BuildContext context, Part part) async {
    int statusCod = await PartService.save(part);

    if (statusCod == 200) {
      _showSnackBar("Sucesso ao salvar ParNumber! ", "Sim");
      if (!_usaScanner) {
        Navigator.pop(context);
        _usaScanner = false;
      } else {
        setState(() {
          temPNCadastradonoSip = false;
          _pnController.text = '';
          _descriptionController.text = '';
        });
      }
    } else {
      _showSnackBar(
          "Falha ao salvar, verifique se os PN já está cadastrado!", "Não");
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
    return WillPopScope(
      onWillPop: () async => true,
      child: SingleChildScrollView(
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
                        readOnly: Responsive.isMobile(context) ? true : false,
                        autofocus: Responsive.isMobile(context) ? false : true,
                        onFieldSubmitted: (String text) async {
                          if (text != null) {
                            //manager.inPnSip.add(text);
                            text = text.trim();
                            Part part = await PartService.browseSip(text);

                            if (part != null) {
                              setState(() {
                                temPNCadastradonoSip = true;
                                _descriptionController.text = part.description;
                              });
                            } else {
                              setState(() {
                                temPNCadastradonoSip = false;
                                _descriptionController.text = '';
                              });
                            }
                          }
                        },
                        controller: _pnController,
                        hint: 'PN',
                        onSaved: (pn) {
                          this.pn = pn;
                        },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "PN obrigatório")
                              .minLength(7, msg: "Mínimo de 7 caractres")
                              .valido(valor);
                        },
                        icon: temPNCadastradonoSip
                            ? Icons.check
                            : Responsive.isDesktop(context)
                                ? Icons.search
                                : FontAwesomeIcons.barcode,
                        color:
                            temPNCadastradonoSip ? Colors.green : Colors.grey,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15, right: 32, left: 32),
                        child: InputCustomizado(
                          autofocus:
                              Responsive.isMobile(context) ? true : false,
                          controller: _descriptionController,
                          hint: 'DESC',
                          onSaved: (desc) {
                            this.desc = desc;
                          },
                          maxLines: null,
                          validador: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "DESC obrigatório")
                                .minLength(7, msg: "Mínimo de 7 caractres")
                                .valido(valor);
                          },
                          icon: null,
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 32, bottom: 15, right: 32, left: 32),
                      child: BotaoCustomizado(
                        texto: 'SALVAR',
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Part part = Part(pn, desc);
                            part.created_by =
                                await UserService.getUserEidPreferentes();
                            _cadastrarPN(context, part);
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
      ),
    );
  }
}
