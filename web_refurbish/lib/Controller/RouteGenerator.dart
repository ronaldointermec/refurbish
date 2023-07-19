import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refurbish_web/View/cadastro/IPRegister.dart';
import 'package:refurbish_web/View/criar/CriarPage.dart';
import 'package:refurbish_web/View/mobile/AlocacaoPage.dart';
import 'package:refurbish_web/View/mobile/RemoverPage.dart';
import 'package:refurbish_web/View/ms/criar/CriarPageMs.dart';
import 'package:refurbish_web/View/ms/ncr/DescricaoDefeito.dart';
import 'package:refurbish_web/View/ms/ncr/Motivo.dart';
import 'package:refurbish_web/View/ms/ncr/OrdemServico.dart';
import 'package:refurbish_web/View/ms/ncr/PartNumber.dart';
import 'package:refurbish_web/View/ms/ncr/Resumo.dart';
import 'package:refurbish_web/View/pagar/PagarPage.dart';
import 'package:refurbish_web/View/reimpressao/ReimprimirPage.dart';
import 'package:refurbish_web/View/report/PecaSolicitadaEntregueView.dart';
import 'package:refurbish_web/View/report/PosicaoDeEstoqueView.dart';

import '../View/login/Login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/criar":
        return MaterialPageRoute(builder: (_) => CriarPage());
      case "/pagar":
        return MaterialPageRoute(builder: (_) => PagarPage());
      case "/estoque":
        return MaterialPageRoute(builder: (_) => PosicaoDeEstoqueView());
      case "/requisicao":
        return MaterialPageRoute(builder: (_) => PecaSolicitadaEntregueView());
      case "/alocacao":
        return MaterialPageRoute(builder: (_) => AlocacaoPage());
      case "/remover":
        return MaterialPageRoute(builder: (_) => RemoverPage());
      case "/ip":
        return MaterialPageRoute(builder: (_) => IPRegister());
      case "/reimpressao":
        return MaterialPageRoute(builder: (_) => ReimprimirPage());
      case "/criarms":
        return MaterialPageRoute(builder: (_) => CriarPageMs());
      case "/gerarncr":
        return MaterialPageRoute(builder: (_) => OrdemServico());
      case "/pn":
        return MaterialPageRoute(
            builder: (_) => PartNumber(
                  order: args,
                ));
      case "/motivo":
        return MaterialPageRoute(
            builder: (_) => Motivo(
                  osPN: args,
                ));
      case "/descricao":
        return MaterialPageRoute(
            builder: (_) => DescricaoDefeito(
                  osPNMotivo: args,
                ));
      case "/resumo":
        return MaterialPageRoute(
            builder: (_) => Resumo(
                  osPNMotivoDesc: args,
                ));
      default:
        // _errorRota();
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Tela não encontrada"),
            ),
            body: Center(
              child: Text("Tela não Encontrada"),
            ),
          );
        });
    }
  }

// static Route<dynamic> _errorRota() {
//   return MaterialPageRoute(builder: (_) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Tela não encontrada"),
//       ),
//       body: Center(
//         child: Text("Tela não Encontrada"),
//       ),
//     );
//   });
// }
}
