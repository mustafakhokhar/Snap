import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/period.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/usecase/expenses_get.dart';

// States
sealed class ExpensesListState {}

class ExpensesInitial extends ExpensesListState {}

class ExpensesLoading extends ExpensesListState {}

class ExpensesLoaded extends ExpensesListState {
  final List<Expense> items;
  final Period period;
  final bool refreshing;
  ExpensesLoaded(this.items, this.period, {this.refreshing = false});
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
  Period? _lastPeriod;
  ExpensesListCubit(this._getExpenses) : super(ExpensesInitial());

  Future<void> load(Period p) async {
    _lastPeriod = p;
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
    // Reuse last period if any; otherwise default to today
    final p = _lastPeriod ?? Period.today();
    await load(p);
  }
}
