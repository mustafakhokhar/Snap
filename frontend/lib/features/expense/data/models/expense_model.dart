import 'package:frontend/features/expense/domain/entity/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    required String id,
    required String name,
    required String category,
    required String description,
    required String title,
    required double amount,
    required DateTime date,
  }) : super(
            title: title,
            amount: amount,
            date: date,
            id: id,
            name: name,
            category: category,
            description: description);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
        id: expense.id,
        name: expense.name,
        category: expense.category,
        description: expense.description,
        title: expense.title,
        amount: expense.amount,
        date: expense.date);
  }
}
