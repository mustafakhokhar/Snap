import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/usecase/add_expense.dart';
import 'package:frontend/features/expense/domain/usecase/get_expenses.dart';

// States
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {
  final List<Expense> expenses;
  ExpenseSuccess(this.expenses);
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}

class AddExpenseLoading extends ExpenseState {}

class AddExpenseSuccess extends ExpenseState {}

class AddExpenseError extends ExpenseState {
  final String message;
  AddExpenseError(this.message);
}

// Cubit
class ExpenseCubit extends Cubit<ExpenseState> {
  final AddExpense addExpense;
  final GetExpenses getExpenses;

  ExpenseCubit({
    required this.addExpense,
    required this.getExpenses,
  }) : super(ExpenseInitial());

  Future<void> loadExpenses({String? period}) async {
    emit(ExpenseLoading());
    try {
      final expenses = await getExpenses(period: period);
      emit(ExpenseSuccess(expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> submitExpense(Expense expense) async {
    emit(AddExpenseLoading());
    try {
      await addExpense.call(expense);
      emit(AddExpenseSuccess());
      // Reload expenses after adding
      await loadExpenses();
    } catch (e) {
      emit(AddExpenseError(e.toString()));
    }
  }
}
