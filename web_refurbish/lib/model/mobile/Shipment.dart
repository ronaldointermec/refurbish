class Shipment {
  int _id;
  String _os;
  String _local;
  bool _is_lab;
  int _status_id;
  String _created_by;
  String _updated_by;

  Shipment();

  Shipment.fromJson(Map<String, dynamic> json)
      : this._id = json["id"],
        this._os = json["os"],
        this._local = json["local"],
        this._is_lab = json["is_lab"],
        this._status_id = json["status_id"];

  Map<String, dynamic> toJson() => {
        "id": this._id,
        "os": this._os,
        "local": this._local,
        "is_lab": this.is_lab,
        "status_id": this._status_id,
        "created_by": this._created_by,
        "updated_by": this._updated_by
      };

  String get updated_by => _updated_by;

  set updated_by(String value) {
    _updated_by = value;
  }

  String get created_by => _created_by;

  set created_by(String value) {
    _created_by = value;
  }

  int get status_id => _status_id;

  set status_id(int value) {
    _status_id = value;
  }

  bool get is_lab => _is_lab;

  set is_lab(bool value) {
    _is_lab = value;
  }

  String get local => _local;

  set local(String value) {
    _local = value;
  }

  String get os => _os;

  set os(String value) {
    _os = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
