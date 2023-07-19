import 'dart:convert';
import 'package:refurbish_web/model/Order.dart';

List<RequisitionMs> MicrosigaRequisitionFromJson(String str) =>
    List<RequisitionMs>.from(
        json.decode(str).map((x) => RequisitionMs.fromJson(x)));

String MicrosigaRequisitionToJson(List<RequisitionMs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequisitionMs {
  RequisitionMs({
    this.id,
    this.statusId,
    this.status,
    this.pn,
    this.position,
    this.description,
    this.updated_by,
    this.order,
  });

  int id;
  int statusId;
  Status status;
  String pn;
  String position;
  String description;
  String updated_by;
  Order order;

  factory RequisitionMs.fromJson(Map<String, dynamic> json) => RequisitionMs(
        id: json["id"],
        statusId: json["status_id"],
        status: Status.fromJson(json["status"]),
        pn: json["pn"],
        position: json["position"],
        description: json["description"],
        updated_by: json["updated_by"],
        order: Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status_id": statusId,
        "pn": pn,
        "position": position,
        "description": description,
        "updated_by": updated_by,
        "order": order.toJson(),
      };
}

class Status {
  String message;

  Status.fromJson(Map<String, dynamic> json) : this.message = json['message'];
}
