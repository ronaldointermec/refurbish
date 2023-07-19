import 'package:refurbish_web/model/Part.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PartService {
  static Future<Part> browseSip(String filter) async {
    print('Consultando PN no SIP...');
    try {
      var _url = Uri.parse(
          '${Global.URL_SIP}/refurbish/getPartnumberInfo?partnumber=$filter');
      http.Response response = await http.get(_url);

      Part part = Part.fromJsonSip(json.decode(response.body));

      if (response.statusCode == 200) {
        return part;
      }
    } catch (err) {
      print("Não foi possível recuperar o PartNUmber: $err");
    }
  }

  static Future<Part> browse(String filter) async {
    print('Consultando PN no REFURBISH...');
    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/parts/$filter');
      http.Response response = await http.get(_url);

      Part part = Part.fromJson(json.decode(response.body));

      if (response.statusCode == 200) {
        return part;
      }
    } catch (err) {
      print("Não foi possível recuperar o PartNUmber: $err");
    }
  }

  static Future<int> save(Part part) async {
    try {
      var json = jsonEncode(part.toJson());

      var _url = Uri.parse('${Global.URL_REFURBISH}/parts/');
      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('Erro ao salvar PartNumber: $err');
    }
  }

}
