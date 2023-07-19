import 'dart:convert';
import 'package:refurbish_web/model/export.dart';
import 'package:universal_html/js.dart';

List<Ncr> NcrFromJson(String str) =>
    List<Ncr>.from(json.decode(str).map((x) => Ncr.fromJson(x)));

String NcrToJson(List<Ncr> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ncr {
  Ncr({
    this.id,
    this.motivo,
    this.desc_problema,
    this.tipo,
    this.mov_microsiga,
    this.pn,
    this.quantidade,
    this.desc_pn,
    this.position,
    this.created_by,
    this.updated_by,
    this.status_id,
    this.order,
  });

  int id;
  String motivo;
  String desc_problema;
  String tipo;
  String mov_microsiga;
  String pn;
  int quantidade;
  String desc_pn;
  String position;
  String created_by;
  String updated_by;
  int status_id;
  Order order;

  factory Ncr.fromJson(Map<String, dynamic> json) => Ncr(
        id: json["id"],
        motivo: json["motivo"],
        desc_problema: json["desc_problema"],
        tipo: json["tipo"],
        mov_microsiga: json["mov_microsiga"],
        pn: json["pn"],
        quantidade: json["quantidade"],
        desc_pn: json["desc_pn"],
        position: json["position"],
        created_by: json["created_by"],
        updated_by: json["updated_by"],
        status_id: json["status_id"],
        order: Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "motivo": motivo,
        "desc_problema": desc_problema,
        "tipo": tipo,
        "mov_microsiga": mov_microsiga,
        "pn": pn,
        "quantidade": quantidade,
        "desc_pn": desc_pn,
        "position": position,
        "created_by": created_by,
        "updated_by": updated_by,
        "status_id": status_id,
        "order": order.toJson(),
      };
}
