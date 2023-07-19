//import 'dart:html';
import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/ms/Ncr.dart';
import 'package:refurbish_web/service/ms/NcrService.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NcrManager implements Manager {
  PublishSubject<List<Ncr>> _collectionNcr = PublishSubject<List<Ncr>>();
  PublishSubject<String> _filterNcr = PublishSubject<String>();

  PublishSubject<String> beep = PublishSubject<String>();

  Stream<List<Ncr>> get browse$ => _collectionNcr.stream;

  Sink<String> get inFilter => _filterNcr.sink;

  NcrManager() {
    _filterNcr.debounceTime(Duration(seconds: 1)).switchMap((filter) async* {
      yield await NcrService.browse(filter);
    }).listen((requisitionMs) async {
      _collectionNcr.add(requisitionMs);
    });

    beep.stream.listen((event) {
      if (kIsWeb) {
       /* new AudioElement("assets/sounds/notification.wav")
          ..autoplay = true
          ..load();*/
      }
    });
  }

  loadNcrAutomatically(String ncr) async {
    while (true) {
      await Future.delayed(Duration(seconds: 10));
      await inFilter.add(ncr);
    }
  }

  @override
  void dispose() {
    _collectionNcr.close();
    _filterNcr.close();
    beep.close();
  }
}
