import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:refurbish_web/model/report/PosicaoEstoque.dart';
import 'package:refurbish_web/settings/Global.dart';

class PosicaoEstoqueService {
  static Future<List<PosicaoEstoque>> browse(Map<String, String> body) async {

    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/report/posicaoEstoque/');

      var corpo = json.encode(body);

      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: corpo);

      Iterable list = json.decode(response.body);

      List<PosicaoEstoque> posicaoEstoqueList = list
          .map((posicaoEstoque) => PosicaoEstoque.fromJson(posicaoEstoque))
          .toList();

      if (response.statusCode == 200) {
        return posicaoEstoqueList;
      }
    } catch (err) {
      print("Não foi possível recuperar o Estoque: $err");
    }
  }
}
