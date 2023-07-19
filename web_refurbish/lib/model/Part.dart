class Part {
  int _id;
  String _pn;
  String _description;
  String _created_by;

  Part(this._pn, this._description);

  Part.fromJson(Map<String, dynamic> json)
      : this._id = json['id'],
        this._pn = json['pn'],
        this._description = json['description'];

  Part.fromJsonSip(Map<String, dynamic> json)
      : this._pn = json['Code'],
        this._description = json['Description'];

  Map<String, dynamic> toJson() => {
        "pn": this.pn,
        "description": this.description,
        "created_by": this.created_by
      };

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get created_by => _created_by;

  set created_by(String value) {
    _created_by = value;
  }

  String get pn => _pn;

  set pn(String value) {
    _pn = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }
}
