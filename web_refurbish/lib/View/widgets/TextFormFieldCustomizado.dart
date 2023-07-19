import 'package:flutter/material.dart';

class TextFormFieldCustomizado extends StatelessWidget {
  final TextEditingController controller;
  final String mensagemPesquisa;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onFieldSubmitted;
  final Color fillColor;
  final Color textColor;
  final IconData icon;
  final GestureTapCallback onTap;
 final bool autofocus;
  const TextFormFieldCustomizado({
    Key key,
    this.controller,
    this.mensagemPesquisa,
    this.onChange,
    this.onFieldSubmitted,
    this.fillColor = const Color(0xFF3C3F54),
    this.textColor = const Color(0xFFFFFFFF),
    this.icon = Icons.search,
    this.onTap, this.autofocus= false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: this.autofocus,
      keyboardType: TextInputType.number,
      controller: this.controller,
      onChanged: onChange,
      onFieldSubmitted: this.onFieldSubmitted,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: this.onTap,
          child: Icon(
            this.icon,
            color: Color(0xFFD1D2D6),
          ),
        ),
        filled: true,
        fillColor: this.fillColor,
        labelText: this.mensagemPesquisa,
        labelStyle: TextStyle(color: Color(0xFFD1D2D6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      style: TextStyle(color: this.textColor),
    );
  }
}
