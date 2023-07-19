import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';

class CounterBuider extends StatelessWidget {
  final Stream<List<Shipment>> stream;
  final Function builder;

  const CounterBuider({Key key, this.stream, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<Shipment>>(

    stream: this.stream,
    onSuccess: (context, List<Shipment> data) =>
        builder(context, data),
    onError: (context, error) => print(error),
    onWaiting: (context) => SizedBox.shrink(),
  );
}
