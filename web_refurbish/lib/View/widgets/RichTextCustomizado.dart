import 'package:flutter/material.dart';

class RichTextCustomizado extends StatelessWidget {
  final String descricao;
  final String titulo;

  const RichTextCustomizado({Key key, this.descricao, this.titulo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: titulo,
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: descricao,
              style: TextStyle(color: Color(0xFF8F919E), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
