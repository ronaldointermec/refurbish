import 'package:http/http.dart' as http;
import 'package:refurbish_web/settings/Global.dart';

class SsoServices {
  static Future<int> getAuthentication(clientId) async {
    try {
      final _url = Uri.parse(Global.URL_SSO+'$clientId');
      // final _url = Uri.parse(Global.URL_SSO);
      final response = await http.get(_url);
      print('retorno da api ${response.statusCode}');
      return response.statusCode;
    } catch (err) {
      print(err);
    }
  }

}
