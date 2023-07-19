import 'package:refurbish_web/model/Order.dart';
import 'package:http/http.dart' as http;
import 'package:refurbish_web/model/Storage.dart';
import 'package:refurbish_web/model/ms/StorageMs.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'dart:convert';

class OrderService {
  static Future<List<Order>> browse(String filter) async {
    print('Consultando OS no SIP');
    try {
      var _url = Uri.parse(
          '${Global.URL_SIP}/refurbish/getOsInfo?serviceOrder=$filter');

      http.Response response = await http.get(_url);//, headers: Global.HEADERS

      Iterable list = json.decode(response.body);

      List<Order> orders =
          list.map((json) => Order.fromJsonSip(json)).toList();

      return orders;
    } catch (err) {
      print('Erro ao recuperar OS: $err');
      return null;

    }
  }

  static Future<int> create(Storage storage) async {
    try {
      final _url = Uri.parse('${Global.URL_REFURBISH}/orders/');

      final json = jsonEncode(storage.toJson());

      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('Erro ao  criar order: $err');
    }
  }


  static Future<String> getStatusOS(String os) async {
    print('Consultando status de OS no SIP');
    List<Order> orders = await OrderService.browse(os);

    return orders[0].status;
  }
}
