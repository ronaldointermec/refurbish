import 'package:flutter/material.dart';
import 'package:refurbish_web/View/criar/CriarPageLeft.dart';
import 'package:refurbish_web/View/criar/CriarPageRight.dart';
import 'package:refurbish_web/View/mobile/DashBoard.dart';
import 'package:refurbish_web/View/widgets/AppBarCostumizada.dart';
import 'package:refurbish_web/View/widgets/AppDrawer.dart';
import 'package:refurbish_web/View/widgets/Responsive.dart';
import 'package:refurbish_web/theme/theme.dart';

class CriarPage extends StatelessWidget {
  const CriarPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: DashBoard(), desktop: DeskTop());
  }
}

class DeskTop extends StatelessWidget {
  const DeskTop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBarCostumizada(
        title: "Refurbish - Requisição",
      ),
      drawer: AppDrawer(),
      // endDrawer: AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.scaffoldBackgroundColor),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Expanded(
              child: CriarPageLeft(),
            ),
            Container(
              width: 1,
              height: _height * 0.5,
              color: Colors.grey,
            ),
            Expanded(
              child: CriarPageRight(),
            )
          ],
        ),
      ),
    );
  }
}
