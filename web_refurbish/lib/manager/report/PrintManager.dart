import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/export.dart';
import 'package:refurbish_web/service/RequisitionService.dart';
import 'package:rxdart/rxdart.dart';

class PrintManager extends Manager {
  final PublishSubject<String> _filterRequisition = PublishSubject<String>();
  final PublishSubject<List<Requisition>> _collectionRequisition =
      PublishSubject<List<Requisition>>();

  Sink<String> get inFilter => _filterRequisition.sink;

  Stream<List<Requisition>> get browse$ => _collectionRequisition.stream;

  PrintManager() {
    _filterRequisition
        .debounceTime(Duration(milliseconds: 500))
        .switchMap((filter) async* {
      yield await RequisitionService.browseReimpressao(filter);
    }).listen((requisition) async {
      _collectionRequisition.add(requisition);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
