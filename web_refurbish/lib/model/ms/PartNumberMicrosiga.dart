
import 'dart:convert';

List<PartNumberMicrosiga> PartNumberMicrosigaFromJson(String str) => List<PartNumberMicrosiga>.from(json.decode(str).map((x) => PartNumberMicrosiga.fromJson(x)));

String PartNumberMicrosigaToJson(List<PartNumberMicrosiga> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PartNumberMicrosiga {
  PartNumberMicrosiga({
    this.code,
    this.name,
    this.quantity,
    this.description,
    this.type,
    this.warehouse,
    this.position,
  });

  String code;
  String name;
  int quantity;
  String description;
  int type;
  String warehouse;
  String position;

  factory PartNumberMicrosiga.fromJson(Map<String, dynamic> json) => PartNumberMicrosiga(
    code: json["Code"],
    name: json["Name"],
    quantity: json["Quantity"],
    description: json["Description"],
    type: json["Type"],
    warehouse: json["Warehouse"],
    position: json["Position"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Name": name,
    "Quantity": quantity,
    "Description": description,
    "Type": type,
    "Warehouse": warehouse,
    "Position": position,
  };
}
