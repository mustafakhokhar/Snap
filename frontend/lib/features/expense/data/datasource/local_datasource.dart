import 'dart:collection';

import 'package:frontend/features/expense/data/models/expense_model.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getByDateRange(DateTime start, DateTime end);
  Future<ExpenseModel> insert(ExpenseDraft draft);
}

class InMemoryExpenseLocalDataSource implements ExpenseLocalDataSource {
  final _items = <ExpenseModel>[];

  @override
  Future<List<ExpenseModel>> getByDateRange(
      DateTime start, DateTime end) async {
    final res = _items
        .where((e) => !e.createdAt.isBefore(start) && !e.createdAt.isAfter(end))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return UnmodifiableListView(res);
  }

  @override
  Future<ExpenseModel> insert(ExpenseDraft draft) async {
    final model = ExpenseModel.fromDraft(draft);
    _items.add(model);
    return model;
  }
}
