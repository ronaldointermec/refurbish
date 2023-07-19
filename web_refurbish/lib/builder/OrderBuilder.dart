import 'package:flutter/material.dart';
import 'package:refurbish_web/model/Order.dart';
import 'package:refurbish_web/helper/Observer.dart';

class OrderBuilder extends StatelessWidget {
  final Function builder;
  final Stream<List<Order>> stream;
  const OrderBuilder({this.builder, this.stream});

  @override
  Widget build(BuildContext context) => Observer<List<Order>>(
        stream: this.stream,
        onSuccess: (context, List<Order> data) => builder(context, data),
        onError: (context, error) => print(error),
        onWaiting: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.44,
            child: LinearProgressIndicator()),
      );
}
