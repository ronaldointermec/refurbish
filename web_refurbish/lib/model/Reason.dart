class Reason {
  final int id;
  final String description;
  final String created_by;
  final String updated_by;
  bool _isChecked = true;
  Reason(this.description, this.created_by, this.updated_by,this.id);

  Reason.fromJson(Map<String, dynamic> json)
      :  id = json["id" ],
        description = json["description"],
        created_by = json["created_by"],
        updated_by = json["updated_by"];

  Map<String, dynamic> toJson() => {
        "description": this.description,
        "created_by": this.created_by,
        "updated_by": this.updated_by,
        "id" : this.id,
  };

  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    _isChecked = value;
  }
}
