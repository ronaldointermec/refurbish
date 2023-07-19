import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/View/mobile/DashBoard.dart';
import 'package:refurbish_web/View/pagar/PagarPageLeft.dart';
import 'package:refurbish_web/View/pagar/PagarPageRight.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/theme/theme.dart';

class PagarPage extends StatelessWidget {
  const PagarPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: DashBoard(), desktop: DeskTop());
  }
}

class DeskTop extends StatelessWidget {
  const DeskTop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCostumizada(title: "Refurbish - Pagar Peça"),
      drawer: AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(8),
            color: AppTheme.scaffoldBackgroundColor),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PagarPageLeft(),
            ),
            Expanded(
              child: PagarPageRight(),
            )
          ],
        ),
      ),
    );
  }
}
