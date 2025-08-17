import 'dart:collection';
import 'package:frontend/core/utils/period.dart';
import 'package:frontend/features/expense/data/models/expense_model.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';

abstract class AbstarctRemoteDataSource {
  Future<ExpenseModel> addExpense(ExpenseDraft draft);
  Future<List<ExpenseModel>> getExpenses(Period period);
}

class RemoteDataSourceFake implements AbstarctRemoteDataSource {
  final List<ExpenseModel> _expenses = [
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

  @override
  Future<List<ExpenseModel>> getExpenses(Period period) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(const Duration(seconds: 1));
    final res = _expenses
        .where((e) =>
            !e.createdAt.isBefore(period.start) &&
            !e.createdAt.isAfter(period.end))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return UnmodifiableListView(res);
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseDraft draft) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(const Duration(seconds: 1));
    _expenses.add(ExpenseModel.fromDraft(draft));
    return ExpenseModel.fromDraft(draft);
  }
}

class RemoteDataSource implements AbstarctRemoteDataSource {
  @override
  Future<ExpenseModel> addExpense(ExpenseDraft draft) async {
    // TODO: Implement addExpense
    return ExpenseModel.fromDraft(draft);
  }

  @override
  Future<List<ExpenseModel>> getExpenses(Period period) async {
    // TODO: Implement getExpenses
    return [];
  }
}
