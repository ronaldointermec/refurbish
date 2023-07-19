import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/ms/RequisitionMs.dart';

class RequisitionBuilderMs extends StatelessWidget {
  final Stream<List<RequisitionMs>> stream;
  final Function builder;

  const RequisitionBuilderMs({Key key, this.stream, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<RequisitionMs>>(

    stream: this.stream,
    onSuccess: (context, List<RequisitionMs> data) =>
        builder(context, data),
    onError: (context, error) => print(error),
    // onWaiting: (context) => LinearProgressIndicator(),
    onWaiting: (context) => SizedBox.shrink(),
  );
}
