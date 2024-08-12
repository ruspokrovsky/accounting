class PositionModel{

  final int id;
  final String positionName;
  final double positionPrice;
  final int addedAt;
  bool? isSelected;
  double? qtyForCart;

  PositionModel({
    required this.id,
    required this.positionName,
    required this.positionPrice,
    required this.addedAt,
    this.isSelected = false,
    this.qtyForCart,
  });

  factory PositionModel.fromJson(Map<String,dynamic> json)
  => PositionModel(
      id: json['id'],
      positionName: json['positionName'],
      positionPrice: json['positionPrice'],
      addedAt: json['addedAt'],
      isSelected: false,);

  Map<String, dynamic> toJson(){
    return {
      'positionName':positionName,
      'positionPrice':positionPrice,
      'addedAt':addedAt,
    };
  }

}