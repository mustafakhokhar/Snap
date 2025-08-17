import 'package:frontend/core/utils/period.dart';
import 'package:frontend/core/utils/result.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Future<Result<List<Expense>>> call(Period period) async {
    return await repository.getByPeriod(period);
  }
  // Future<Result<List<Expense>>> call(Period p) => repo.getByPeriod(p);
}
