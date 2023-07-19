import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/report/PecaSolicitadaEntregue.dart';
import 'package:refurbish_web/service/report/PecaSolicitadaEntregueService.dart';
import 'package:rxdart/rxdart.dart';

class PecaSolicitadaEntregueManager extends Manager {
  PublishSubject<List<PecaSolicitadaEntregue>>
      _collectionPecaSolicitadaEntregue =
      PublishSubject<List<PecaSolicitadaEntregue>>();

  PublishSubject<Map<String, String>> _filterPecaSolicitadaEntregue =
      PublishSubject<Map<String, String>>();

  Stream<List<PecaSolicitadaEntregue>> get browse$ =>
      _collectionPecaSolicitadaEntregue.stream;

  Sink<Map<String, String>> get inFilter => _filterPecaSolicitadaEntregue.sink;

  PecaSolicitadaEntregueManager() {
    _filterPecaSolicitadaEntregue
        .debounceTime(Duration(milliseconds: 500))
        .switchMap((body) async* {
      yield await PecaSolicitadaEntregueService.browse(body);
    }).listen((pecaSolicitadaEntregue) async {
      _collectionPecaSolicitadaEntregue.add(pecaSolicitadaEntregue);
    });
  }

  @override
  void dispose() {
    _collectionPecaSolicitadaEntregue.close();
  }
}
