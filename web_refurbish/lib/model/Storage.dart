import 'package:refurbish_web/model/ItemStorage.dart';
import 'package:refurbish_web/model/Order.dart';

class Storage {
  Order order;
  List<ItemStorage> storages;
  int priority;
  String created_by;
  int status_id;

  Storage({this.order, this.storages, this.priority,this.status_id, this.created_by});

  Map<String, dynamic> toJson() => {
        "os": this.order.os,
        "contract_type": order.contract_type,
        "customer_name": order.customer_name,
        "part_number": order.part_number,
        "serial_number": order.serial_number,
        "days": order.days,
        "priority": priority,
        "status_id": status_id,
        "created_by": created_by,
        "storages": this.storages != null
            ? this.storages.map((i) => i.toJson()).toList()
            : null
      };
}
