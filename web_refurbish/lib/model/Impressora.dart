import 'dart:io';

import 'package:refurbish_web/service/mobile/PrintService.dart';

class Impressora {
  //String ip = '199.61.149.18';
  int port = 9100;

  Future<bool> print({String customer, String order}) async {
    try {
      if (customer.length > 38) customer = customer.substring(0, 37);

      Socket socket = await Socket.connect(PrintService.getIP(), port);

      if (socket != null) {
        socket.write("RCW358PF*B1;"
            "f3;o55,74;c6,0,0,2;w2;h29;d3,"
            "#order#H2;f3;o25,151;c26;b0;h9;w9;d3,"
            "$orderH3;f3;o84,36;c26;b1;h7;w7;d3,"
            "$customerD0Rl13E*,111");
        socket.destroy();
        return true;


      }
      return false;

      // Socket.connect(ip, port).then((Socket socket) {
      //   if (socket != null) {
      //     socket.write("RCW358PF*B1;"
      //         "f3;o55,74;c6,0,0,2;w2;h29;d3,"
      //         "#order#H2;f3;o25,151;c26;b0;h9;w9;d3,"
      //         "$orderH3;f3;o84,36;c26;b1;h7;w7;d3,"
      //         "$customerD0Rl13E*,111");
      //     socket.destroy();
      //     return true;
      //   }
      // });
    } catch (err) {
      return false;
    }
  }
}
