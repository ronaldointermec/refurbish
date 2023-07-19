import 'package:flutter/material.dart';

SnackBar SnackBarCustomizada(
        BuildContext context, GlobalKey<ScaffoldState> key, String text, String ans) =>
    SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
        content: Row(
          children: <Widget>[Text(text)],
        ));

//
// SnackBarCustomizada(BuildContext context, GlobalKey<ScaffoldState> key,
//     String text, String ans) {
//   final snackBar = SnackBar(
//       duration: Duration(seconds: 5),
//       backgroundColor: ans.compareTo("Sim") == 0 ? Colors.green : Colors.red,
//       content: Row(
//         children: <Widget>[Text(text)],
//       ));
//
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
