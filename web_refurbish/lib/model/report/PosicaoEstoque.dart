class PosicaoEstoque {
  final String pn;
  final String description;
  final String status;
  final String address;
  final int qtd;
  final String created_by;
  final String  updated_by;

  PosicaoEstoque(
      {this.pn, this.description, this.qtd, this.status, this.address,this.created_by,this.updated_by});

  PosicaoEstoque.fromJson(Map<String, dynamic> json)
      : pn = json["parts.pn"],
        description = json["parts.description"],
        qtd = json["parts.qtd"],
        status = json["status.description"],
        address = json["localizations.address"],
        created_by = json["created_by"],
        updated_by = json["updated_by"];
}
