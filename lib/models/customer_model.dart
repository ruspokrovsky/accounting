class CustomerModel{

  final int id;
  final String customerName;
  final String customerPhone;
  final int customerBirthday;
  final int addedAt;

  CustomerModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerBirthday,
    required this.addedAt,
  });

  factory CustomerModel.fromJson(Map<String,dynamic> json)
  => CustomerModel(
  id: json['id'],
  customerName: json['customerName'],
  customerPhone: json['customerPhone'],
  customerBirthday: json['customerBirthday'],
  addedAt: json['addedAt']);

  Map<String, dynamic> toJson(){
    return {
      'customerName':customerName,
      'customerPhone':customerPhone,
      'customerBirthday':customerBirthday,
      'addedAt':addedAt,
    };
  }

  static empty(){
    return CustomerModel(
        id: 0,
        customerName: '',
        customerPhone: '',
        customerBirthday: 0,
        addedAt: 0);
  }

}