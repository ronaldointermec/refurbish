import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;
  final bool visible;
  final Color backgroundColor;

  BotaoCustomizado(
      {@required this.texto,
      this.corTexto = Colors.white,
      this.onPressed,
      this.visible = true, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: this.visible,
      child: SizedBox( height: 80, width: 120,
        child: TextButton(

          style: TextButton.styleFrom(
            backgroundColor: this.backgroundColor,
            elevation: 0,
            shadowColor: Colors.purple,
          ),
          child: Text(
            this.texto,
            style: TextStyle(
                /*fontFamily: Global.fontMontserratMedium ,*/
                color: this.corTexto,
                fontSize: 14),
          ),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
