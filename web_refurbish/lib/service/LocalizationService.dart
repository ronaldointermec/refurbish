import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalizationService {
  static Future<Localization> browse(String filter) async {
    print('Consultando locaL....');
    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/localizations/$filter');
      http.Response response = await http.get(_url);

      Localization localization =
          Localization.fromJson(json.decode(response.body));

      if (response.statusCode == 200) {
        return localization;
      }
    } catch (err) {
      print("Não foi possível recuperar o local: $err");
    }
  }

  static Future<int> save(Localization localization) async {
    try {
      var json = jsonEncode(localization.toJson());

      var _url = Uri.parse('${Global.URL_REFURBISH}/localizations/');
      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('Erro ao salvar local: $err');
    }
  }
}
