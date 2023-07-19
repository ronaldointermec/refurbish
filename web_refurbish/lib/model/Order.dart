class Order {
  final String os;
  final String contract_type;
  final String customer_name;
  final String part_number;
  final String serial_number;
  final String days;
   String status;

  Order(this.os, this.contract_type, this.customer_name, this.part_number,
      this.serial_number, this.days);

  Order.fromJson(Map<String, dynamic> json)
      : this.os = json['os'],
        this.contract_type = json['contract_type'],
        this.customer_name = json['customer_name'],
        this.part_number = json['part_number'],
        this.serial_number = json['serial_number'],
        this.days = json['days'];


  Order.fromJsonSip(Map<String, dynamic> json)
      : this.os = json['Code'],
        this.contract_type = json['ContractType'],
        this.customer_name = json['Name'],
        this.part_number = json['Partnumber'],
        this.serial_number = json['Serialnumber'],
        this.days = json['Date'],
        this.status = json['Status'];

  Map<String, dynamic> toJson() => {
    "os": this.os,
    "contract_type": this.contract_type,
    "customer_name": this.customer_name,
    "part_number": this.part_number,
    "serial_number": this.serial_number,
    "days": this.days,
  };

}
