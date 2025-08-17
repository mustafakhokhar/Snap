import 'package:frontend/core/utils/result.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<Result<Expense>> call(ExpenseDraft draft) async {
    return await repository.add(draft);
  }
  // Future<Result<Expense>> call(ExpenseDraft draft) => repo.add(draft);
}
