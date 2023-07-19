import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';
import 'package:refurbish_web/service/mobile/ShipmentService.dart';
import 'package:rxdart/rxdart.dart';

class ShipmentManagerLab implements Manager {
  PublishSubject<List<Shipment>> _collectionShipment =
  PublishSubject<List<Shipment>>();
  PublishSubject<Shipment> _filterShipment = PublishSubject<Shipment>();

  Stream<List<Shipment>> get browse$ => _collectionShipment.stream;

  Sink<Shipment> get inFilter => _filterShipment.sink;

  ShipmentManagerLab() {
    _filterShipment
        .debounceTime(Duration(seconds: 1))
        .switchMap((os) async* {
      yield await ShipmentService.browseLab(os);
    }).listen((shipment) {
      _collectionShipment.add(shipment);
    });
  }

  void dispose() {
    _collectionShipment.close();
  }
}
