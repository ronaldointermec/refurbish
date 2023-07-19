import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:refurbish_web/model/ms/Ncr.dart';
import 'package:refurbish_web/settings/Global.dart';

class NcrService {

  static Future<bool> update(Ncr ncr) async {
    try {
      var json = jsonEncode(ncr.toJson());
      var _url = Uri.parse('${Global.URL_REFURBISH}/ncr');

      http.Response response =
      await http.patch(_url, headers: Global.HEADERS, body: json);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print('Erro ao salvar Shipment $err');
    }

    return false;
  }

  static Future<List<Ncr>> browse(String filter) async {
    final _url = Uri.parse('${Global.URL_REFURBISH}/ncr/$filter');

    try {
      http.Response response = await http.get(_url);

      List<Ncr> list = NcrFromJson(response.body);

      if (response.statusCode == 200) {

        return list;
      }
    } catch (err) {
      print(err);
    }
  }

  static Future<int> create(Ncr ncr) async {
    final _url = Uri.parse('${Global.URL_REFURBISH}/ncr');
    try {
      final json = jsonEncode(ncr.toJson());
      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('erro ao criar NCR $err');
    }
  }
}
