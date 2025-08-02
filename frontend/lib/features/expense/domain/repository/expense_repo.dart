import 'package:frontend/features/expense/domain/entity/expense.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
}
