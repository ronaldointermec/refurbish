import 'package:flutter/material.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/PartLocalization.dart';

class PLBuilder extends StatelessWidget {
  final Stream<PartLocalization> stream;
  final Function builder;
  const PLBuilder({Key key, this.stream, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<PartLocalization>(
    stream: this.stream,
    onSuccess: (context, PartLocalization data) =>
        builder(context, data),
    onError: (context, error) => print(error),
    onWaiting: (context) => SizedBox.shrink(),
  );
}
