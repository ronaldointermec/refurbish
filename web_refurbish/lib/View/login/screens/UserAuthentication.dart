import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:refurbish_web/model/User.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/View/widgets/widgets.dart';
import 'package:refurbish_web/manager/UserManager.dart';
import 'package:refurbish_web/service/UserService.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'package:validadores/validadores.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:refurbish_web/main.dart';

class UserAuthentication extends StatefulWidget {
  final double height;
  final double width;

  const UserAuthentication({Key key, this.height, this.width})
      : super(key: key);

  @override
  _UserAuthenticationState createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {


  final _formKey = GlobalKey<FormState>();
  User _usuario;
  bool _showPassword;

  _generateMd5(manager, BuildContext context) async {
    // Navigator.pushReplacementNamed(context, '/pagar');
    var content = new Utf8Encoder().convert(_usuario.password);
    var md5 = crypto.md5;
    User user = await UserService.logar(
        User.logar(_usuario.Username, md5.convert(content).toString()),
        context);

    if (user != null) {
      manager.inUserPreferences.add(user);
      Navigator.pushReplacementNamed(context, '/pagar');
    }
  }

  @override
  void initState() {
    super.initState();
    _showPassword = false;
    _usuario = User();
  }

  @override
  Widget build(BuildContext context) {
    UserManager manager = context.fetch<UserManager>();
    final double _height = MediaQuery.of(context).size.height;
    final bool isDesktop = Responsive.isDesktop(context);

    return Material(
      elevation: 60.0,
      child: TweenAnimationBuilder(
        duration: Duration(seconds: 2),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (BuildContext context, double opacity, Widget widget) {
          return SingleChildScrollView(
            child: Opacity(
              opacity: opacity,
              child: Container(
                decoration: isDesktop
                    ? BoxDecoration(
                        // color: Colors.white70,
                        color: Color(0xFF262A41),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0.5,
                            spreadRadius: 0.0,
                            offset: Offset(
                                0.0, 0.0), // shadow direction: bottom righ
                          )
                        ],
                      )
                    : BoxDecoration(
                        color: AppTheme.scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(),
                        ],
                      ),
                height: isDesktop ? this.widget.height : _height,
                width: this.widget.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/honeywell.png',
                        width: MediaQuery.of(context).size.height * .35,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, right: 32, left: 32),
                              child: InputCustomizado(
                                controller: null,
                                hint: 'EID',
                                onSaved: (eid) {
                                  _usuario.Username = eid;
                                },
                                maxLines: null,
                                validador: (valor) {
                                  return Validador()
                                      .add(Validar.OBRIGATORIO,
                                          msg: "EID obrigatório")
                                      .maxLength(7, msg: "Máxio de 7 caractres")
                                      .valido(valor);
                                },
                                icon: null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 15, right: 32, left: 32),
                              child: InputCustomizado(
                                controller: null,
                                hint: 'SENHA',
                                obscure: !_showPassword ? true : false,
                                onSaved: (senha) {
                                  _usuario.password = senha;
                                },
                                maxLines: 1,
                                validador: (valor) {
                                  return Validador()
                                      .add(Validar.OBRIGATORIO,
                                          msg: "Senha obrigatória")
                                      .valido(valor);
                                },
                                icon: !_showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 32, bottom: 15, right: 32, left: 32),
                              child: BotaoCustomizado(
                                texto: 'ENTRAR',
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    _generateMd5(manager, context);
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
            ),
          );
        },
      ),
    );
  }
}
