import 'package:frontend/core/utils/period.dart';
import 'package:frontend/core/utils/result.dart';
import 'package:frontend/features/expense/domain/entity/category.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';

abstract class ExpenseRepository {
  Future<Result<List<Expense>>> getByPeriod(Period period);
  Future<Result<Expense>> add(ExpenseDraft draft);
}

abstract class CategoryRepository {
  Future<Result<List<Category>>> getAll();
  Future<Result<Category>> add(Category category);
}
