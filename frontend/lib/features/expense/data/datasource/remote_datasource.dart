import 'dart:collection';
import 'package:frontend/core/utils/period.dart';
import 'package:frontend/features/expense/data/models/category_model.dart';
import 'package:frontend/features/expense/data/models/expense_model.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';

abstract class AbstarctRemoteDataSource {
  Future<ExpenseModel> addExpense(ExpenseDraft draft);
  Future<List<ExpenseModel>> getExpenses(Period period);
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> addCategory(CategoryModel category);
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

  final List<CategoryModel> _categories = [
    CategoryModel(
      id: '1',
      name: 'Food',
      color: '#FF6B6B',
      emoji: '🍔',
      description:
          'Food and dining expenses including restaurants, groceries and snacks',
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '2',
      name: 'Travel',
      color: '#4ECDC4',
      emoji: '✈️',
      description:
          'Travel expenses including flights, hotels, and transportation',
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '3',
      name: 'Study',
      color: '#45B7D1',
      emoji: '📚',
      description:
          'Education expenses including books, courses and tuition fees',
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '4',
      name: 'Shopping',
      color: '#96CEB4',
      emoji: '🛍️',
      description:
          'Shopping expenses including clothes, electronics and accessories',
      createdAt: DateTime.now(),
    ),
    CategoryModel(
      id: '5',
      name: 'Entertainment',
      color: '#D4A5A5',
      emoji: '🎮',
      description: 'Entertainment expenses including movies, games and events',
      createdAt: DateTime.now(),
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

  @override
  Future<List<CategoryModel>> getCategories() async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(const Duration(seconds: 1));
    return UnmodifiableListView(_categories);
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    // Simulate API call (replace with Dio or HTTP later)
    await Future.delayed(const Duration(seconds: 1));
    _categories.add(category);
    return category;
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

  @override
  Future<List<CategoryModel>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) {
    // TODO: implement addCategory
    throw UnimplementedError();
  }
}
