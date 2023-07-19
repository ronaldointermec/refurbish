import 'package:flutter/material.dart';
import 'package:refurbish_web/View/mobile/DashBoard.dart';
import 'package:refurbish_web/View/reimpressao/Reimprimir.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';

class ReimprimirPage extends StatelessWidget {
  //const ReimprimirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: DashBoard(), desktop: Reimprimir());
  }
}
