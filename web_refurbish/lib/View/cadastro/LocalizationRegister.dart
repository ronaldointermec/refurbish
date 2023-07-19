import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refurbish_web/View/criar/CriarPage.dart';
import 'package:refurbish_web/View/widgets/BotaoCustomizado.dart';
import 'package:refurbish_web/View/widgets/InputCustomizado.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/manager/ScannerManager.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/service/LocalizationService.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:validadores/Validador.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LocalizationRegister extends StatelessWidget {
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

  String address;
  TextEditingController _addressController = TextEditingController();
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

  @override
  void dispose() {
    if (!kIsWeb) {
      scannerManager.dispose();
    }
    super.dispose();
  }

  _onDecode() async {
    scannerManager.getCode.listen((code) {
      if (code != null) {
        _usaScanner = true;
        setState(() {
          if (code.contains("REF")) _addressController.text = code;
        });
      }
    });
  }

  _cadastrarLocal(BuildContext context, Localization localization) async {
    int statusCod = await LocalizationService.save(localization);

    if (statusCod == 200) {
      _showSnackBar("Sucesso ao salvar Local! ", "Sim");
      if (!_usaScanner) {
        Navigator.pop(context);
        _usaScanner = false;
      } else {
        setState(() {
          _addressController.text = '';
        });
      }
    } else {
      _showSnackBar(
          "Falha ao salvar Local, verifique se já está cadastrado!", "Não");
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
                        autofocus: true,
                        readOnly: Responsive.isMobile(context) ? true : false,
                        controller: _addressController,
                        hint: 'Local',
                        onSaved: (address) {
                          this.address = address;
                        },
                        maxLines: null,
                        validador: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO,
                                  msg: "Local obrigatório")
                              .minLength(4, msg: "Mínimo de 4 caractres")
                              .valido(valor);
                        },
                        icon: Responsive.isMobile(context)
                            ? FontAwesomeIcons.barcode
                            : null,
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
                            Localization locaization = Localization(address);
                            locaization.created_by =
                                await UserService.getUserEidPreferentes();

                            _cadastrarLocal(context, locaization);
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
