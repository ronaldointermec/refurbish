import 'package:refurbish_web/interface/Manager.dart';
import 'package:refurbish_web/model/Order.dart';
import 'package:refurbish_web/service/OrderService.dart';
import 'package:rxdart/rxdart.dart';

class OrderManager implements Manager {
  PublishSubject<List<Order>> _collectionOrder = PublishSubject<List<Order>>();
  PublishSubject<String> _filterOrder = PublishSubject<String>();

  Sink<String> get inFilter => _filterOrder.sink;

  Stream<List<Order>> get browse$ => _collectionOrder.stream;

  OrderManager() {
    _filterOrder
        .debounceTime(Duration(milliseconds: 500))
        .switchMap((filter) async* {
      yield await OrderService.browse(filter);
    }).listen((requisition) async {
      _collectionOrder.add(requisition);
    });
  }

  @override
  void dispose() {
    _collectionOrder.close();
    _filterOrder.close();
  }
}
