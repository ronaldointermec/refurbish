import 'package:flutter/material.dart';
import 'package:refurbish_web/model/PartLocalization.dart';
import 'package:refurbish_web/helper/Observer.dart';
import 'package:refurbish_web/model/ms/PartNumberMicrosiga.dart';

class PartLocalizationBuilder extends StatelessWidget {
  final Stream<List<PartLocalization>> stream;
  final Function builder;

  const PartLocalizationBuilder({Key key, this.stream, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Observer<List<PartLocalization>>(

        stream: this.stream,
        onSuccess: (context, List<PartLocalization> data) =>
            builder(context, data),
        onError: (context, error) => print(error),
        onWaiting: (context) => LinearProgressIndicator(),
      );
}
