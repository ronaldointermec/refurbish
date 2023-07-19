class ItemStorageMs {
  final String pn;
  final String address;
  final String description;

  ItemStorageMs(
      {this.pn, this.address, this.description});

  Map<String,dynamic> toJson()=>{
    "pn": this.pn,
    "position": this.address,
    "description":this.description

  };
}
