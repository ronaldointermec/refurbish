import 'package:refurbish_web/model/mobile/Shipment.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShipmentService {
  static Future<List<Shipment>> browse(String filter) async {
    List<Shipment> shipment = [];
    try {
      var _url = Uri.parse('${Global.URL_REFURBISH}/shipment/$filter');

      http.Response response = await http.get(_url, headers: Global.HEADERS);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);

        if (list.length > 0) {
          shipment = list.map((json) => Shipment.fromJson(json)).toList();
          return shipment;
        } else {
          print('Não foi encontrado nenhum shipment');
        }
      } else {
        print('Erro ao carregar shipments');
      }
    } catch (err) {
      print("Erro ao carregar shipments");
    }
  }

  static Future<List<Shipment>> browseLab(Shipment shipment) async {
    print('Consultando shipment...');
    List<Shipment> shipmentList = [];
    try {
      var corpo = jsonEncode(shipment.toJson());

      var _url = Uri.parse('${Global.URL_REFURBISH}/shipmentConsultaOS');

      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: corpo);


      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        shipmentList = list.map((json) => Shipment.fromJson(json)).toList();
        return shipmentList;
      } else {

        print('Erro ao carregar shipments');
      }
    } catch (err) {
      print("Erro ao carregar shipments: $err");
    }
  }

  static Future<int> save(Shipment shipment) async {
    try {
      var json = jsonEncode(shipment.toJson());

      var _url = Uri.parse('${Global.URL_REFURBISH}/shipment');

      http.Response response =
          await http.post(_url, headers: Global.HEADERS, body: json);

      return response.statusCode;
    } catch (err) {
      print('Erro ao salvar Shipment $err');
    }
  }

  static Future<bool> update(Shipment shipment) async {
    try {
      var json = jsonEncode(shipment.toJson());
      var _url = Uri.parse('${Global.URL_REFURBISH}/shipment');

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
}
