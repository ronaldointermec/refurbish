import 'package:shared_preferences/shared_preferences.dart';

class PrintService {
  static Future<bool> setIP(String ip) async {
    try {
      var sharedInstance = await SharedPreferences.getInstance();
      await sharedInstance.setString('ip', ip);
      return true;
    } catch (err) {
      return false;
    }
  }

  static Future<String> getIP() async {
    try {
      var sharedInstance = await SharedPreferences.getInstance();
      return await sharedInstance.getString('ip');
    } catch (err) {
      print("Erro ao recupera IP");
    }
  }
}
