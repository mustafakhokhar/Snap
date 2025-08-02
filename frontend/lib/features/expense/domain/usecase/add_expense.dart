import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/repository/expense_repo.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<void> call(Expense expense) async {
    await repository.addExpense(expense);
  }
}
