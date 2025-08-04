// Abstarct class for the remote data source
import 'package:frontend/features/expense/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  // Add a new expense
  Future<void> addExpense(ExpenseModel expense);
}