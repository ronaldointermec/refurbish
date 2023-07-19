import 'package:flutter/material.dart';
import 'package:refurbish_web/View/mobile/DashBoard.dart';
import 'package:refurbish_web/View/pagar/PagarPage.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Responsive(mobile: DashBoard(), desktop: PagarPage());
}
