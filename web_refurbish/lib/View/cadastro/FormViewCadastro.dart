import 'package:flutter/material.dart';

class FormViewCadastro extends StatefulWidget {
  final Widget child;
  final String title;

  const FormViewCadastro({Key key, this.child, this.title}) : super(key: key);

  @override
  _FormViewCadastroState createState() => _FormViewCadastroState();
}

class _FormViewCadastroState extends State<FormViewCadastro> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      //alignment: AlignmentDirectional.topStart,
      children: [
        Positioned(
            right: -5.0,
            top: 60.0,
            child: AlertDialog(
              title: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
              ),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateSetter) {
                return SizedBox(
                  width: 400,
                  child: widget.child,
                );
              }),
            ))
      ],
    );
  }
}
