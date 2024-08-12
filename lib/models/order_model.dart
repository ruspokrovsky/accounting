import 'package:forleha/models/customer_model.dart';

class OrderModel{
  final int id;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final int addedAt;
  final int acceptDate;
  final int shipmentDate;
  final int orderStatus;
  final int invoice;
  final double totalSum;
  late CustomerModel? customerData;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.addedAt,
    required this.acceptDate,
    required this.shipmentDate,
    required this.orderStatus,
    required this.invoice,
    required this.totalSum,
    this.customerData,
  });

  factory OrderModel.fromJson(Map<String,dynamic> json)
  => OrderModel(
    id: json['id'],
    customerId: json['customerId'],
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    addedAt: json['addedAt'],
    acceptDate: json['acceptDate'],
    shipmentDate: json['shipmentDate']??0,
    orderStatus: json['orderStatus'],
    invoice: json['invoice'],
    totalSum: json['totalSum'],
  );

  Map<String, dynamic> toJson(){
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'addedAt': addedAt,
      'acceptDate': acceptDate,
      'shipmentDate': shipmentDate,
      'orderStatus': orderStatus,
      'invoice': invoice,
      'totalSum': totalSum,
    };
  }

  static empty(){
    return OrderModel(
      id: 0,
      customerId: 0,
      customerName: '',
      customerPhone: '',
      addedAt: 0,
      acceptDate: 0,
      shipmentDate: 0,
      orderStatus: 0,
      invoice: 0,
      totalSum: 0,
    );
  }

}