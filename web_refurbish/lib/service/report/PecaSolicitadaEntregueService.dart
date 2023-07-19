import 'package:refurbish_web/model/report/PecaSolicitadaEntregue.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PecaSolicitadaEntregueService {

  static Future<List<PecaSolicitadaEntregue>> browse(
      Map<String, String> body) async {
    try {
      var _url =
          Uri.parse('${Global.URL_REFURBISH}/report/pecaSolicitadaEntregue/');

      var corpo = json.encode(body);

      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: corpo);



      Iterable list = json.decode(response.body);

      List<PecaSolicitadaEntregue> pecaSolicitadaEntregueList = list
          .map((pecaSolicitadaEntregue) =>
              PecaSolicitadaEntregue.fromJson(pecaSolicitadaEntregue))
          .toList();

      if (response.statusCode == 200) {

        //pecaSolicitadaEntregueList.forEach((element) { print(element.status);});

        return pecaSolicitadaEntregueList;
      }
    } catch (err) {
      print("Não foi possível recuperar requisições: $err");
    }
  }
}
