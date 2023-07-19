import 'package:flutter/material.dart';
import 'package:refurbish_web/model/Requisition.dart';
import 'package:refurbish_web/helper/Observer.dart';

class RequisitionBuilder extends StatelessWidget {
  final Function builder;
  final Stream<List<Requisition>> stream;

  const RequisitionBuilder(
      {/*Key key,*/ this.builder, this.stream}); // : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<Requisition>>(
        stream: this.stream,
        onSuccess: (context, List<Requisition> data) => builder(context, data),
        onError: (context, error) => print(error),
        onWaiting: (context) => SizedBox.shrink(),
      );
}
