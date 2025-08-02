import 'package:frontend/features/expense/data/datasource/remote_datasource.dart';
import 'package:frontend/features/expense/data/models/expense_model.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/repository/expense_repo.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await remoteDataSource.addExpense(model);
  }
}
