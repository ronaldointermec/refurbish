import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';

class StartScreenBuilder extends StatelessWidget {

  final Function builder;
  final Stream<Widget> stream;


  const StartScreenBuilder({Key key, this.builder, this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<Widget>(
    stream: this.stream,
    onSuccess: (context, Widget data) => builder(context, data),
    onError: (context, error) => print(error),
    onWaiting: (context) => SizedBox.shrink(),
  );
}
