import 'package:refurbish_web/model/Order.dart';
import 'package:refurbish_web/model/ms/ItemStorageMs.dart';

class StorageMs {
  Order order;
  ItemStorageMs item;
  String created_by;
  int status_id;

  StorageMs({this.order, this.item, this.created_by, this.status_id});

  Map<String, dynamic> toJson() => {
        "created_by": created_by,
        "order": this.order.toJson(),
        "item": this.item.toJson(),
        "status_id": this.status_id,
      };
}
