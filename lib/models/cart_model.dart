class CartModel{

  final int id;
  final int customerId;
  final int positionId;
  final String positionName;
  final double positionPrice;
  late  double positionQty;
  late double positionAmount;
  int orderId;

  CartModel({
    required this.id,
    required this.customerId,
    required this.positionId,
    required this.positionName,
    required this.positionPrice,
    required this.positionQty,
    required this.positionAmount,
    required this.orderId,
  });

  factory CartModel.fromJson(Map<String,dynamic> json)
  => CartModel(
      id: json['id'],
      customerId: json['customerId'],
      positionId: json['positionId'],
      positionName: json['positionName'],
      positionPrice: json['positionPrice'],
      positionQty: json['positionQty'],
      positionAmount: json['positionAmount'],
      orderId: json['orderId']??0,
  );



  Map<String, dynamic> toJson(){
    return {
      'customerId': customerId,
      'positionId': positionId,
      'positionName': positionName,
      'positionPrice': positionPrice,
      'positionQty': positionQty,
      'positionAmount': positionAmount,
    };
  }

  Map<String, dynamic> toJsonForOrders(){
    return {
      'customerId': customerId,
      'positionId': positionId,
      'positionName': positionName,
      'positionPrice': positionPrice,
      'positionQty': positionQty,
      'positionAmount': positionAmount,
      'orderId': orderId,
    };
  }

}