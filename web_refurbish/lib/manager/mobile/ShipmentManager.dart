import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/mobile/Shipment.dart';
import 'package:refurbish_web/service/mobile/ShipmentService.dart';
import 'package:rxdart/rxdart.dart';

class ShipmentManager implements Manager {
  PublishSubject<List<Shipment>> _collectionShipment =
      PublishSubject<List<Shipment>>();
  PublishSubject<String> _filterShipment = PublishSubject<String>();

  Stream<List<Shipment>> get browse$ => _collectionShipment.stream;

  Sink<String> get inFilter => _filterShipment.sink;

  ShipmentManager() {
    _filterShipment
        .debounceTime(Duration(seconds: 1))
        .switchMap((filter) async* {
      yield await ShipmentService.browse(filter);
    }).listen((shipment) {
      _collectionShipment.add(shipment);
    });
  }

  void dispose() {
    _collectionShipment.close();
  }
}
