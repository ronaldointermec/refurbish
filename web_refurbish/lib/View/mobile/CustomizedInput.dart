import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomizedInput extends StatelessWidget {
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
  final bool readOnly;
  final Color fillColor;
  final ValueChanged<String> onChanged;

  CustomizedInput(
      {@required this.controller,
        @required this.hint,
        this.obscure = false,
        this.autofocus = false,
        this.keyboarType = TextInputType.text,
        this.inputFormatters,
        this.maxLines = 1,
        this.validador,
        this.onSaved,
        this.icon,
        this.onPressed, this.readOnly,
        this.fillColor=Colors.white, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      readOnly: readOnly,
      controller: this.controller,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.keyboarType,
      inputFormatters: this.inputFormatters,
      validator: this.validador,
      maxLines: this.maxLines,
      onSaved: this.onSaved,
      style: TextStyle( fontSize: 30, color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: this.hint,
        hintStyle: TextStyle( fontSize: 24),
        filled: true,
        fillColor: this.fillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide:BorderSide(color: Colors.black38,) ),

        prefixIcon: IconButton(
          icon: Icon(icon, color: Colors.black38),
          onPressed: onPressed,
        ),
        // enabledBorder: (OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(6),
        //     borderSide: BorderSide(color: Colors.grey)))
      ),
    );
  }
}
