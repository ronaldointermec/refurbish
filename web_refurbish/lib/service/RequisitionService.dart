import 'package:refurbish_web/model/Requisition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:refurbish_web/settings/Global.dart';

class RequisitionService {
  static Future<List<Requisition>> browse(String os) async {
    Map<String, dynamic> map = {
      "os": os,
      "status_id": Global.isEmprestimo ? 4 : 2
    };

    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/requisitions');
      http.Response response = await http.post(_url,
          headers: Global.HEADERS, body: json.encode(map));

      Iterable list = json.decode(response.body);
      List<Requisition> requisitions =
          list.map((json) => Requisition.fromJson(json)).toList();

      if (response.statusCode == 200) {
        return requisitions;
      }
    } catch (err) {
      print("Não foi possível recuperar a requisição: $err");
    }
  }

  static Future<List<Requisition>> browseReimpressao(String filter) async {
    Map<String, dynamic> map = {"os": filter};

    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/reimpressao');
      http.Response response = await http.post(_url,
          headers: Global.HEADERS, body: json.encode(map));

      Iterable list = json.decode(response.body);
      List<Requisition> requisitions =
          list.map((json) => Requisition.fromJson(json)).toList();

      if (response.statusCode == 200) {
        return requisitions;
      }
      // return ;
    } catch (err) {
      print("Não foi possível recuperar a requisição: $err");
    }
  }

  static Future<int> close(Requisition requisition) async {
    final _url = Uri.parse('${Global.URL_REFURBISH}/requisitions/');

    final json = jsonEncode(requisition.toJson());
    print(json);

    http.Response response =
        await http.patch(_url, headers: Global.HEADERS, body: json);

    return response.statusCode;
  }

  static Future<int> criar(Requisition requisition) async {
    final _url = Uri.parse('${Global.URL_REFURBISH}/loans/');

    final json = jsonEncode(requisition.toJson());

    http.Response response =
        await http.patch(_url, headers: Global.HEADERS, body: json);

    return response.statusCode;
  }

  static Future<int> update(Requisition requisition) async {
    final _url = Uri.parse('${Global.URL_REFURBISH}/emprestimo/');

    final json = jsonEncode(requisition.toJson());

    http.Response response =
        await http.patch(_url, headers: Global.HEADERS, body: json);

    return response.statusCode;
  }
}
