import 'dart:async';
import 'package:refurbish_web/model/Requisition.dart';
import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';
import 'package:refurbish_web/service/RequisitionService.dart';
import 'package:refurbish_web/service/mobile/ShipmentService.dart';
import 'package:refurbish_web/settings/Global.dart';
import 'package:rxdart/rxdart.dart';

class RequisitionManager implements Manager {
  final PublishSubject<String> _filterRequisition = PublishSubject<String>();
  final PublishSubject<List<Requisition>> _collectionRequisition =
      PublishSubject<List<Requisition>>();
  final PublishSubject<Requisition> _emprestimo = PublishSubject<Requisition>();
  final PublishSubject<Requisition> _requisition =
      PublishSubject<Requisition>();
  final PublishSubject<Requisition> _requisitionItem =
      PublishSubject<Requisition>();

  Sink<String> get inFilter => _filterRequisition.sink;

  Stream<List<Requisition>> get browse$ => _collectionRequisition.stream;

  Sink<Requisition> get inEmprestimo => _emprestimo.sink;

  Stream<Requisition> get emprestimo$ => _emprestimo.stream;

  Requisition req;
  Shipment shipment;

  Sink<Requisition> get inRequisiton => _requisitionItem.sink;

  Stream<Requisition> get requisition$ => _requisition.stream;

  RequisitionManager() {
    _requisitionItem
        .debounceTime(Duration(milliseconds: 250))
        .switchMap((requisition) async* {
      if (requisition != null) {
        req = requisition;
        shipment = Shipment();
        shipment.os = requisition.order.os;
        yield await ShipmentService.browseLab(shipment);
      } else {
        req = requisition;
        _requisition.add(requisition);
      }
    }).listen((shipmentList) async {
      if (shipmentList.length > 0) {
        req.local = shipmentList[0].local;
      }
      _requisition.add(req);
    });

    _filterRequisition
        .debounceTime(Duration(milliseconds: 500))
        .switchMap((filter) async* {
      yield await RequisitionService.browse(filter);
    }).listen((requisition) async {
      _collectionRequisition.add(requisition);
    });
  }

  loadRequisitionAutomatically(String requisition) async {
    while (true) {
      await Future.delayed(Duration(seconds: 10));

      if (Global.podeConsultarRequisicao) {
        await inFilter.add(requisition);
      }
    }
  }

  @override
  void dispose() {
    _requisition.close();
    _collectionRequisition.close();
    _requisitionItem.close();
  }
}
