import 'package:refurbish_web/model/PartLocalization.dart';
import 'package:http/http.dart' as http;
import 'package:refurbish_web/model/ms/PartNumberMicrosiga.dart';

import 'dart:convert';

import 'package:refurbish_web/settings/Global.dart';

class PartLocalizationService {
  static Future<List<PartLocalization>> browse(String filter) async {
    print("Consultando estoque...");
    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/partlocalizations/$filter');
      http.Response response =
          await http.get(_url, headers: Global.HEADERS).then((value) => value);

      //if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);

      List<PartLocalization> partlocalizations =
          list.map((json) => PartLocalization.fromJson(json)).toList();

      return partlocalizations;
    } catch (err) {
      print(" Erro ao carregar estoque $err");
    }
  }

  static Future<int> save(PartLocalization partLocalization) async {
    try {
      var json = jsonEncode(partLocalization.toJsonAlocacao());
      var _url = Uri.parse('${Global.URL_REFURBISH}/partlocalizations/');
      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('Erro ao salvar alocação: $err');
    }
  }

  static Future<int> update(PartLocalization partLocalization) async {
    try {
      var json = jsonEncode(partLocalization.toJsonAlocacao());

      var _url = Uri.parse('${Global.URL_REFURBISH}/partlocalizations/');
      http.Response response =
          await http.patch(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('Erro ao salvar alocação: $err');
    }
  }

  static Future<List<PartNumberMicrosiga>> browseMS(String filter) async {
    print('Consultando PN no MS...');
    var _body = jsonEncode([
      {"Code": "SV"}
    ]);
    try {
      var _url =
          Uri.parse('${Global.URL_SIP}/Alocacao/GPBWAOP?partnumber=${filter}');
      http.Response _response =
          await http.post(_url, headers: Global.HEADERS, body: _body);

      List<PartNumberMicrosiga> lista =
          PartNumberMicrosigaFromJson(_response.body);

      if (_response.statusCode == 200) {
        return lista;
      }
    } catch (err) {
      print("Não foi possível recuperar o PartNUmber: $err");
    }
  }
}
