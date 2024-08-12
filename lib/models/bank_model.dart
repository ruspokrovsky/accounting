class BankModel{
  final int id;
  final String admission;
  final String expense;
  final double admissionSum;
  final double expenseSum;
  final String admissionDescription;
  final String expenseDescription;
  final int addedAt;
  final int expAt;

  BankModel({
    required this.id,
    required this.admission,
    required this.expense,
    required this.admissionSum,
    required this.expenseSum,
    required this.admissionDescription,
    required this.expenseDescription,
    required this.addedAt,
    required this.expAt,
  });

  factory BankModel.fromJson(Map<String,dynamic> json)
  => BankModel(
      id: json['id'],
      admission: json['admission'],
      expense: json['expense'],
      admissionSum: json['admissionSum'],
      expenseSum: json['expenseSum'],
      admissionDescription: json['admissionDescription'],
      expenseDescription: json['expenseDescription'],
      addedAt: json['addedAt'],
      expAt: json['expAt'],
  );

  Map<String, dynamic> toJson(){
    return {
      'admission': admission,
      'expense': expense,
      'admissionSum': admissionSum,
      'expenseSum': expenseSum,
      'admissionDescription': admissionDescription,
      'expenseDescription': expenseDescription,
      'addedAt': addedAt,
      'expAt': expAt,
    };
  }

}

class CurrentBankModel{
  final int id;
  final String sum;
  final String date;
  final String description;

  CurrentBankModel({
    required this.id,
    required this.sum,
    required this.date,
    required this.description,
  });}