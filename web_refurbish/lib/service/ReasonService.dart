import 'package:refurbish_web/model/Reason.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:refurbish_web/settings/Global.dart';

class ReasonService {
  static Future<List<Reason>> browse() async {
    print('Consultado motivo...');
    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/reasons/');
      http.Response response = await http.get(_url);

      Iterable list = json.decode(response.body);

      List<Reason> reasons =
          list.map((reason) => Reason.fromJson(reason)).toList();

      if (response.statusCode == 200) {
        return reasons;
      }
    } catch (err) {
      print("Não foi possível recuperar o Movito: $err");
    }
  }

  static Future<int> save(Reason reason) async {
    try {
      var json = jsonEncode(reason.toJson());
      var _url = Uri.parse('${Global.URL_REFURBISH}/reasons/');
      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('Erro ao salvar Motivo: $err');
    }
  }
}
