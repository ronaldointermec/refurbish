import 'package:http/http.dart' as http;
import 'package:refurbish_web/model/ms/RequisitionMs.dart';
import 'package:refurbish_web/model/ms/StorageMs.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'dart:convert';

class NcrService {
  static Future<bool> update(RequisitionMs requisition) async {
    try {
      var json = jsonEncode(requisition.toJson());
      var _url = Uri.parse('${Global.URL_REFURBISH}/loan');

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

  static Future<List<RequisitionMs>> browse(String filter) async {
    final _url = Uri.parse('${Global.URL_REFURBISH}/loan/$filter');

    try {
      http.Response response = await http.get(_url);

      List<RequisitionMs> list = MicrosigaRequisitionFromJson(response.body);

      if (response.statusCode == 200) {
        return list;
      }
    } catch (err) {
      print(err);
    }
  }

  static Future<int> create(StorageMs storage) async {
    final _url = Uri.parse('${Global.URL_REFURBISH}/loan/');
    try {
      final json = jsonEncode(storage.toJson());

      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);
      return response.statusCode;
    } catch (err) {
      print('Erro ao  criar order: $err');
    }
  }
}
