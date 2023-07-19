class Data {
  String Username;
  String Name;

  Data({this.Username,this.Name});

  Map<String, dynamic> toJson() {
    //   final Map<String, dynamic> data = Map<String, dynamic>();
    //     data["Username"] = this.Username;
    //   return data;

    return {"Username": this.Username, "Name": this.Name};
  }
}
