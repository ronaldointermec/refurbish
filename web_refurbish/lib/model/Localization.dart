class Localization {
  int _id;
  String _address;
  String _created_by;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Localization(this._address);

  Localization.fromJson(Map<String, dynamic> json)
      : this._id = json['id'],
        this._address = json['address'];

  Map<String, dynamic> toJson() =>
      {"address": this._address, "created_by": this._created_by};

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get created_by => _created_by;

  set created_by(String value) {
    _created_by = value;
  }
}
