import 'package:frontend/features/expense/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(ExpenseModel expense);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  @override
  Future<void> addExpense(ExpenseModel expense) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(Duration(seconds: 1));
    print("Expense sent to API: ${expense.toJson()}");
  }
}