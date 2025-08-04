import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/repository/expense_repo.dart';

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Future<List<Expense>> call({String? period}) async {
    return await repository.getExpenses(period: period);
  }
}
