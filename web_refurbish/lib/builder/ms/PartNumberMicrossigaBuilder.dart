import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/ms/PartNumberMicrosiga.dart';

class PartNumberMicrossigaBuilder extends StatelessWidget {
  final Stream<List<PartNumberMicrosiga>> stream;
  final Function builder;

  const PartNumberMicrossigaBuilder({Key key, this.stream, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<PartNumberMicrosiga>>(

        stream: this.stream,
        onSuccess: (context, List<PartNumberMicrosiga> data) =>
            builder(context, data),
        onError: (context, error) => print(error),
        onWaiting: (context) => LinearProgressIndicator(),
      );
}
