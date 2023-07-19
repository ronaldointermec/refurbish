import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InputCustomizado extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType keyboarType;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;
  final Function(String) validador;
  final Function(String) onSaved;
  final IconData icon;
  final VoidCallback onPressed;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onFieldSubmitted;
  final Color color;
  final bool readOnly;

  InputCustomizado(
      {@required this.controller ,
      @required this.hint,
      this.obscure = false,
      this.autofocus = false,
      this.keyboarType = TextInputType.text,
      this.inputFormatters,
      this.maxLines = 1,
      this.validador,
      this.onSaved,
      this.icon,
      this.onPressed,
      this.onChanged,
      this.onFieldSubmitted, this.color= Colors.grey, this.readOnly=false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      readOnly: readOnly,
         onFieldSubmitted: onFieldSubmitted,
      onChanged: this.onChanged,
      controller: this.controller,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.keyboarType,
      inputFormatters: this.inputFormatters,
      validator: this.validador,
      maxLines: this.maxLines,
      onSaved: this.onSaved,
      style: TextStyle(
          /*fontFamily: Global.fontMontserratMedium,*/
          fontSize: 14,
          color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: this.hint,
        hintStyle:
            TextStyle(/*fontFamily: Global.fontMontserratRegular,*/ fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey)),

        suffixIcon: IconButton(
          icon: Icon(icon, color: this.color),
          onPressed: onPressed,
        ),
        // enabledBorder: (OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(6),
        //     borderSide: BorderSide(color: Colors.grey)))
      ),
    );
  }
}
