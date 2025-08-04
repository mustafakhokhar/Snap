import 'package:frontend/features/expense/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpenses({String? period});
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  @override
  Future<void> addExpense(ExpenseModel expense) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(Duration(seconds: 1));
    print("Expense sent to API: ${expense.toJson()}");
  }

  @override
  Future<List<ExpenseModel>> getExpenses({String? period}) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(Duration(seconds: 1));

    // Mock data for demonstration
    return [
      ExpenseModel(
        id: '1',
        name: 'John Doe',
        category: 'Food',
        description: 'Lunch at restaurant',
        title: 'Lunch',
        amount: 25.50,
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      ExpenseModel(
        id: '2',
        name: 'John Doe',
        category: 'Transport',
        description: 'Uber ride',
        title: 'Transport',
        amount: 15.00,
        date: DateTime.now(),
      ),
    ];
  }
}
