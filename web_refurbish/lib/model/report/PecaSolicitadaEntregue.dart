class PecaSolicitadaEntregue {
  final int id;
  final String created_by;
  final String updated_by;
  final String created_at;
  final String updated_at;
  final String os;
  final String contract_type;
  final String days;
  final String reason;
  final String address;
  final String pn;
  final String description;
  final String status;

  PecaSolicitadaEntregue(
      {this.id,
      this.created_by,
      this.updated_by,
      this.created_at,
      this.updated_at,
      this.os,
      this.contract_type,
      this.days,
      this.reason,
      this.address,
      this.description,
      this.pn,
      this.status});

  PecaSolicitadaEntregue.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        created_by = json["created_by"],
        updated_by = json["updated_by"],
        created_at = json["created_at"],
        updated_at = json["updated_at"],
        os = json["order.os"],
        contract_type = json["order.contract_type"],
        days = json["order.days"],
        reason = json["requisitionStorages.reasons.description"],
        address = json["requisitionStorages.partlocalizations.localizations.address"],
        pn = json["requisitionStorages.partlocalizations.parts.pn"],
        description = json["requisitionStorages.partlocalizations.parts.description"],
        status = json["status.description"];
}
