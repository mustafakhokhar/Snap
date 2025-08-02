import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/usecase/add_expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  AddExpenseState({this.isLoading = false, this.isSuccess = false, this.error});

  AddExpenseState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return AddExpenseState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

class AddExpenseCubit extends Cubit<AddExpenseState> {
  final AddExpense addExpense;

  AddExpenseCubit(this.addExpense) : super(AddExpenseState());

  Future<void> submitExpense(Expense expense) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await addExpense(expense);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}