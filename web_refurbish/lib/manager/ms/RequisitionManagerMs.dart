//import 'dart:html';
import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/ms/RequisitionMs.dart';
import 'package:refurbish_web/service/ms/RequisitionServiceMs.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class RequisitionManagerMs implements Manager {
  PublishSubject<List<RequisitionMs>> _collectionRequisitionMS =
      PublishSubject<List<RequisitionMs>>();
  PublishSubject<String> _filterRequisitionMS = PublishSubject<String>();

  PublishSubject<String> beep = PublishSubject<String>();

  Stream<List<RequisitionMs>> get browse$ => _collectionRequisitionMS.stream;

  Sink<String> get inFilter => _filterRequisitionMS.sink;

  RequisitionManagerMs() {
    _filterRequisitionMS
        .debounceTime(Duration(seconds: 1))
        .switchMap((filter) async* {
      yield await NcrService.browse(filter);
    }).listen((requisitionMs) async {
      _collectionRequisitionMS.add(requisitionMs);
    });

    // dispara um beep sempre que houver uma nova requisição
    beep.stream.listen((value) {

      if(kIsWeb) {
        /*new AudioElement("assets/sounds/notification.wav")
          ..autoplay = true
          ..load();*/

      }
    });
  }

  loadRequisitionAutomatically(String requisition) async {
    while (true) {
      await Future.delayed(Duration(seconds: 10));
      await inFilter.add(requisition);
    }
  }

  @override
  void dispose() {
    _collectionRequisitionMS.close();
    _filterRequisitionMS.close();
    beep.close();
  }
}
