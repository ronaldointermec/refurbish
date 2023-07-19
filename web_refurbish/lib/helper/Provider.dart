import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Overseer.dart';

class Provider extends InheritedWidget{
  final Overseer data;

  Provider({Key key, Widget child, this.data}) : super(key: key, child: child);

  static Overseer of(BuildContext context){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>()).data;

  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
        throw false;
  }

}