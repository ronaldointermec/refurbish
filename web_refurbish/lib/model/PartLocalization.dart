import 'package:refurbish_web/model/Localization.dart';
import 'package:refurbish_web/model/Part.dart';

class PartLocalization {
  int id;
  Part part;
  Localization localization;
  bool isSelected = false;
  int _reason_id;
  int _qtd;
  String _created_by;

  PartLocalization(this.id, this.part, this.localization);

  PartLocalization.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.localization = Localization.fromJson(json['localizations']),
        this.part = Part.fromJson(json['parts']);

  Map<String, dynamic> toJson() => {
        'id': this.id,
      };

  Map<String, dynamic> toJsonAlocacao() => {
        "id": this.id,
        "pn": this.part.pn,
        "address": this.localization.address,
        "created_by": this.created_by,
        "quantity": this._qtd
      };

  String get created_by => _created_by;

  set created_by(String value) {
    _created_by = value;
  }

  int get qtd => _qtd;

  set qtd(int value) {
    _qtd = value;
  }

  int get reason_id => _reason_id;

  set reason_id(int value) {
    _reason_id = value;
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return part.pn;
      case 1:
        return localization.address;
        break;
      case 2:
        int size = part.description.length;
        if (size <= 30)
          return part.description;
        else if (size > 30 && size <= 60)
          return part.description.substring(0, 30) +
              '\n' +
              part.description.substring(30, size);
        else if (size > 60 && size <= 90)
          return part.description.substring(0, 30) +
              '\n' +
              part.description.substring(30, 60) +
              '\n' +
              part.description.substring(60, size);
        else
          return part.description.substring(0, 30);
    }
  }
}
