import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {

  final Widget mobile;
  final Widget desktop;

  const Responsive({Key key, @required this.mobile, @required this.desktop})
      : super(key: key);

  static bool isMobile (BuildContext context) => MediaQuery.of(context).size.width < 1000;
  static bool isDesktop (BuildContext context) => MediaQuery.of(context).size.width >= 1000;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxWidth >= 1000 ? desktop : mobile;
    });
  }
}
