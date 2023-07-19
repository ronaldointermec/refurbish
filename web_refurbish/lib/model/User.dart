
class User {
  int Code;
  String Name;
  String Username;
  String password;
  int IdDepartment;
  bool Active;
  Map<String, dynamic> Access;

  User();

  User.logar(this.Username, this.password);

   User.userPreferences(this.Name, this.Username);

  User.fromJson(Map<String, dynamic> json)
      : this.Code = json['Code'],
        this.Name = json['Name'],
        this.Username = json['Username'],
        this.IdDepartment = json['IdDepartment'],
        this.Active = json['Active'],
        this.Access = json['Access'];

  Map toJason() {
    return {"User": this.Username, "Md5Pass": this.password};
  }
}
