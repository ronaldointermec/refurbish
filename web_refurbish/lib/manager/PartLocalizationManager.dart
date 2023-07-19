import 'package:refurbish_web/model/PartLocalization.dart';
import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/service/PartLocalizationService.dart';

import 'package:rxdart/rxdart.dart';

class PartLocalizationManager implements Manager{
  PublishSubject<List<PartLocalization>> _collectionPartLocalization =
      PublishSubject<List<PartLocalization>>();

  PublishSubject<String> _filterPartLocalization = PublishSubject<String>();

  PublishSubject<PartLocalization> _partLocalization = PublishSubject<PartLocalization>();

  Sink<PartLocalization> get inPartLocalization => _partLocalization.sink;
  Stream<PartLocalization> get partLocalization$ => _partLocalization.stream;

  Stream<List<PartLocalization>> get browse$ =>
      _collectionPartLocalization.stream;


  Sink<String> get inFilter => _filterPartLocalization.sink;

  PartLocalizationManager() {
    _filterPartLocalization
        .debounceTime(Duration(seconds: 1))
        .switchMap((filter) async* {
      yield await PartLocalizationService.browse(filter);
        }).listen((partLocalization) async {
      _collectionPartLocalization.add(partLocalization);
    });


  }

  @override
  void dispose() {
    _partLocalization.close();
    _collectionPartLocalization.close();
    _filterPartLocalization.close();
  }
}
