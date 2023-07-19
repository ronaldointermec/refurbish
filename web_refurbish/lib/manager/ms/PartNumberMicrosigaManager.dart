import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/service/ms/PartMSService.dart';
import 'package:rxdart/rxdart.dart';
import 'package:refurbish_web/model/ms/PartNumberMicrosiga.dart';

class PartNumberMicrosigaManager implements Manager {
  PublishSubject<List<PartNumberMicrosiga>> _collectionPartNumberMicrosiga =
      PublishSubject<List<PartNumberMicrosiga>>();
  PublishSubject<String> _filterPartNumberMicrosiga = PublishSubject<String>();

  Stream<List<PartNumberMicrosiga>> get browse$ => _collectionPartNumberMicrosiga.stream;

  Sink<String> get inFilter => _filterPartNumberMicrosiga.sink;

  PartNumberMicrosigaManager() {
    _filterPartNumberMicrosiga
        .debounceTime(Duration(seconds: 1))
        .switchMap((filter) async* {
      yield await PartMSService.browse(filter);
    })
        .listen((partNumberMicrosiga) async {
      _collectionPartNumberMicrosiga.add(partNumberMicrosiga);
    });
  }

  @override
  void dispose() {
    _collectionPartNumberMicrosiga.close();
    _filterPartNumberMicrosiga.close();
  }
}
