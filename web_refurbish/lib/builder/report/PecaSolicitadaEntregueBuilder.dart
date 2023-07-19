import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/report/PecaSolicitadaEntregue.dart';

class PecaSolicitadaEntregueBuilder extends StatelessWidget {
  final Function builder;
  final Stream<List<PecaSolicitadaEntregue>> stream;

  const PecaSolicitadaEntregueBuilder({Key key, this.builder, this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<PecaSolicitadaEntregue>>(
      stream: this.stream,
      onSuccess: (context, List<PecaSolicitadaEntregue> data) =>
          builder(context, data),
      onError: (context, error) => print(error),
      onWaiting: (context) => Column(
            children: [
              Container(
                width: 1400,
                child: LinearProgressIndicator(),
              ),
              Expanded(child: Container())
            ],
          ));
}
