import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refurbish_web/View/ms/ncr/DescricaoDefeito.dart';
import 'package:refurbish_web/View/ms/ncr/Motivo.dart';
import 'package:refurbish_web/View/ms/ncr/OrdemServico.dart';
import 'package:refurbish_web/View/ms/ncr/PartNumber.dart';
import 'package:refurbish_web/View/ms/ncr/Resumo.dart';
import 'package:refurbish_web/helper/Overseer.dart';
import 'package:refurbish_web/helper/Provider.dart';
import 'package:refurbish_web/manager/ms/NcrManager.dart';
import 'package:refurbish_web/manager/ms/PartNumberMicrosigaManager.dart';
import 'package:refurbish_web/manager/ReasonManager.dart';
import 'package:refurbish_web/manager/UserManager.dart';
import 'package:refurbish_web/manager/mobile/ShipmentManager.dart';
import 'package:refurbish_web/manager/mobile/ShipmentManagerLab.dart';
import 'package:refurbish_web/manager/ms/RequisitionManagerMs.dart';
import 'package:refurbish_web/manager/report/PecaSolicitadaEntregueManager.dart';
import 'package:refurbish_web/manager/report/PosicaoStoqueManager.dart';
import 'package:refurbish_web/manager/report/PrintManager.dart';
import 'package:refurbish_web/theme/theme.dart';
import 'Controller/RouteGenerator.dart';
import 'View/login/StartScreen.dart';
import 'manager/OrderManager.dart';
import 'manager/PartLocalizationManager.dart';
import 'manager/RequisitionManager.dart';

void main() {
  //altera a cor dos ícones da status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white70));

  runApp(
    MyApp(),
  );
}

extension MyExtention on BuildContext {
  T fetch<T>() => Provider.of(this).fetch<T>();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      key: UniqueKey(),
      data: Overseer({
        RequisitionManager: () => RequisitionManager(),
        OrderManager: () => OrderManager(),
        PartLocalizationManager: () => PartLocalizationManager(),
        UserManager: () => UserManager(),
        ReasonManager: () => ReasonManager(),
        PosicaoStoqueManager: () => PosicaoStoqueManager(),
        PecaSolicitadaEntregueManager: () => PecaSolicitadaEntregueManager(),
        ShipmentManager: () => ShipmentManager(),
        ShipmentManagerLab: () => ShipmentManagerLab(),
        PrintManager: () => PrintManager(),
        PartNumberMicrosigaManager: () => PartNumberMicrosigaManager(),
        RequisitionManagerMs: () => RequisitionManagerMs(),
        NcrManager: () => NcrManager(),
      }),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Refurbish',
        theme: AppTheme.getTheme(context),
         // home:OrdemServico(),
        //home:PartNumber(),
        // home: DescricaoDefeito(),
        //home: Motivo(),
        //  home: Resumo(),
         home: StartScreen(),
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
