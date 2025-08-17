import 'package:frontend/features/expense/data/models/expense_model.dart';

abstract class AbstarctRemoteDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpenses({String? period});
}

class RemoteDataSourceFake implements AbstarctRemoteDataSource {
  @override
  Future<void> addExpense(ExpenseModel expense) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(const Duration(seconds: 1));
    print("Expense sent to API: ${expense.toJson()}");
  }

  @override
  Future<List<ExpenseModel>> getExpenses({String? period}) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for demonstration
    return [
      ExpenseModel(
        id: '2',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now(),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '3',
        title: 'Dinner',
        amount: 250.00,
        createdAt: DateTime.now(),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '4',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now(),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '5',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now(),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '1',
        title: 'Lunch',
        amount: 25.50,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '6',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '7',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '8',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '9',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
      ExpenseModel(
        id: '10',
        title: 'Transport',
        amount: 15.00,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        currency: '',
        categoryId: '',
        merchant: '',
        note: '',
        paymentMethod: '',
      ),
    ];
  }
}

class RemoteDataSource implements AbstarctRemoteDataSource {
  @override
  Future<void> addExpense(ExpenseModel expense) async {
    // TODO: Implement addExpense
  }

  @override
  Future<List<ExpenseModel>> getExpenses({String? period}) async {
    // TODO: Implement getExpenses
    return [];
  }
}
