import 'package:flutter/material.dart';
import 'package:refurbish_web/model/Requisition.dart';
import 'package:refurbish_web/helper/Observer.dart';

class RequisitionItemBuider extends StatelessWidget {
  final Function builder;
  final Stream<Requisition> stream;

  const RequisitionItemBuider(
      {/*Key key,*/ this.builder, this.stream}); // : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<Requisition>(
    stream: this.stream,
    onSuccess: (context, Requisition data) => builder(context, data),
    onError: (context, error) => print(error),
    onWaiting: (context) =>  Center(
      child: Text('Selecione uma OS :)'),
    ),
  );
}
