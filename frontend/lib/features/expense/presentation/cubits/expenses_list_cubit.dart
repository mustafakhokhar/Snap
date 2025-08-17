import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/period.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/usecase/get_expenses.dart';

// States
sealed class ExpensesListState {}

class ExpensesInitial extends ExpensesListState {}

class ExpensesLoading extends ExpensesListState {}

class ExpensesLoaded extends ExpensesListState {
  final List<Expense> items;
  final Period period;
  ExpensesLoaded(this.items, this.period);
}

class ExpensesEmpty extends ExpensesListState {
  final Period period;
  ExpensesEmpty(this.period);
}

class ExpensesError extends ExpensesListState {
  final String message;
  ExpensesError(this.message);
}

// Cubits
class ExpensesListCubit extends Cubit<ExpensesListState> {
  final GetExpenses _getExpenses;
  ExpensesListCubit(this._getExpenses) : super(ExpensesInitial());

  Future<void> load(Period p) async {
    emit(ExpensesLoading());
    final res = await _getExpenses(p);
    res.fold(
      (f) => emit(ExpensesError(f.message)),
      (items) => items.isEmpty
          ? emit(ExpensesEmpty(p))
          : emit(ExpensesLoaded(items, p)),
    );
  }

  Future<void> refresh() async {
    if (state is ExpensesLoaded) {
      final p = (state as ExpensesLoaded).period;
      await load(p);
    }
  }
}
