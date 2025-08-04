import 'package:frontend/features/expense/data/datasource/api_interface.dart';
import 'package:frontend/features/expense/data/models/expense_model.dart';

// Implementation of the remote data source
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  @override
  Future<void> addExpense(ExpenseModel expense) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(Duration(seconds: 1));
    print("Expense sent to API: ${expense.toJson()}");
  }
}

