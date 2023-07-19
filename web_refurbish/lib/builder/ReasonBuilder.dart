import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/Reason.dart';

class ReasonBuilder extends StatelessWidget {
  final Stream<List<Reason>> stream;
  final Function builder;

  const ReasonBuilder({Key key, this.stream, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<Reason>>(
      stream: this.stream,
      onSuccess: (context, List<Reason> data) => builder(context, data),
      onError: (context, err) => print(err),
      onWaiting: (context) => LinearProgressIndicator());
}
