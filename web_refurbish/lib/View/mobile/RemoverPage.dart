import 'package:flutter/material.dart';
import 'package:refurbish_web/View/mobile/Remover.dart';
import 'package:refurbish_web/View/pagar/PagarPage.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';

class RemoverPage extends StatelessWidget {
  const RemoverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Responsive(mobile: Remover(), desktop: PagarPage());
}
