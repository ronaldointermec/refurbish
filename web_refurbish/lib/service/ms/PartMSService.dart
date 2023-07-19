import 'package:http/http.dart' as http;
import 'package:refurbish_web/model/ms/PartNumberMicrosiga.dart';

import 'dart:convert';

import 'package:refurbish_web/settings/Global.dart';

class PartMSService {


  static Future<List<PartNumberMicrosiga>> browse(String filter) async {
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
