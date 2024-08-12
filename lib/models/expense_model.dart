class ExpenseModel{

  final int id;
  final String expense;
  final String expenseCategory;
  final double expenseSum;
  final String expenseDescription;
  final int addedAt;

  ExpenseModel({
    required this.id,
    required this.expense,
    required this.expenseCategory,
    required this.expenseSum,
    required this.expenseDescription,
    required this.addedAt,
  });

  factory ExpenseModel.fromJson(Map<String,dynamic> json)
  => ExpenseModel(
      id: json['id'],
      expense: json['expense'],
      expenseCategory: json['expenseCategory'],
      expenseSum: json['expenseSum'],
      expenseDescription: json['expenseDescription'],
      addedAt: json['addedAt'],
  );

  Map<String, dynamic> toJson(){
    return {
      'expense': expense,
      'expenseCategory': expenseCategory,
      'expenseSum': expenseSum,
      'expenseDescription': expenseDescription,
      'addedAt': addedAt,
    };
  }

}