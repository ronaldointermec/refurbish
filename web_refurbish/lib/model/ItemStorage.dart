class ItemStorage {
  final int part_id;
  final int reason_id;
  final String address;
  final String part_localization_id;

  ItemStorage(
      {this.part_id, this.reason_id, this.address, this.part_localization_id});

  Map<String,dynamic> toJson()=>{
    "part_id": this.part_id,
    "reason_id": this.reason_id,
    "address": this.address,
    "part_localization_id":this.part_localization_id

  };
}
