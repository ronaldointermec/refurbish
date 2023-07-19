import 'package:flutter/material.dart';
import 'package:refurbish_web/View/pagar/PagarPage.dart';
import 'package:refurbish_web/helper/StartScreenBuilder.dart';
import 'package:refurbish_web/service/UserService.dart';

import 'Login.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key key}) : super(key: key);

  Future<Widget> getScreen(context) async {
    String eid = await UserService.getUserEidPreferentes();
    if (eid == null) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
   else {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PagarPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StartScreenBuilder(
        stream: Stream.fromFuture(getScreen(context)),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          return snapshot.data;
        });
  }
}
