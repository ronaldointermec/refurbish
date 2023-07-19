import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;
  final bool visible;

  BotaoCustomizado(
      {@required this.texto, this.corTexto = Colors.white, this.onPressed, this.visible = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: this.visible,
      child: RaisedButton(
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          this.texto,
          style: TextStyle(/*fontFamily: Global.fontMontserratMedium ,*/color: this.corTexto, fontSize: 14),
        ),
        color: Colors.blue,
        padding: EdgeInsets.fromLTRB(31, 22, 32, 22),
        onPressed: this.onPressed,
      ),
    );
  }
}
