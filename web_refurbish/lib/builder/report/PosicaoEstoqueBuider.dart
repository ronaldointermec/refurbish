import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/report/PosicaoEstoque.dart';

class PosicaoEstoqueBuider extends StatelessWidget {
  final Function builder;
  final Stream<List<PosicaoEstoque>> stream;

  const PosicaoEstoqueBuider({Key key, this.builder, this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<PosicaoEstoque>>(
      stream: this.stream,
      onSuccess: (context, List<PosicaoEstoque> data) => builder(context, data),
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
