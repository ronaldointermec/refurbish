import 'package:flutter/material.dart';
import 'package:refurbish_web/View/mobile/Alocacao.dart';
import 'package:refurbish_web/View/pagar/PagarPage.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';

class AlocacaoPage extends StatelessWidget {
  const AlocacaoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Responsive(mobile: Alocacao(), desktop: PagarPage());
}
