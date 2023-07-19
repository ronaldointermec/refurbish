import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/ms/Ncr.dart';

class NcrBuilder extends StatelessWidget {
  final Stream<List<Ncr>> stream;
  final Function builder;

  const NcrBuilder({Key key, this.stream, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<Ncr>>(

    stream: this.stream,
    onSuccess: (context, List<Ncr> data) =>
        builder(context, data),
    onError: (context, error) => print(error),
    // onWaiting: (context) => LinearProgressIndicator(),
    onWaiting: (context) => SizedBox.shrink(),
  );
}
