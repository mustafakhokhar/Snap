import 'package:frontend/features/expense/data/datasource/ocr_datasource.dart';
import 'package:frontend/features/expense/data/datasource/voice_datasource.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/usecase/expense_add.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum DraftSource { manual, ocr, voice }

class AddExpenseState {
  final ExpenseDraft draft;
  final DraftSource source;
  final bool isSaving;
  final String? error;

  AddExpenseState(
      {required this.draft,
      required this.source,
      this.isSaving = false,
      this.error});

  AddExpenseState copyWith(
          {ExpenseDraft? draft,
          DraftSource? source,
          bool? isSaving,
          String? error}) =>
      AddExpenseState(
          draft: draft ?? this.draft,
          source: source ?? this.source,
          isSaving: isSaving ?? this.isSaving,
          error: error);
}

class AddExpenseCubit extends Cubit<AddExpenseState> {
  final AddExpense _addExpense;
  final OCRDataSource _ocr;
  final VoiceDataSource _voice;
  AddExpenseCubit(this._addExpense, this._ocr, this._voice)
      : super(AddExpenseState(
            draft: ExpenseDraft(expenseDate: DateTime.now(), currency: 'PKR'),
            source: DraftSource.manual));

  void startManual() => emit(state.copyWith(source: DraftSource.manual));

  Future<void> scanReceipt(Object imageLike) async {
    final parsed = await _ocr.parseExpenseFromImage(imageLike);
    emit(state.copyWith(
        draft: _merge(state.draft, parsed),
        source: DraftSource.ocr,
        error: null));
  }

  Future<void> voiceCapture() async {
    final parsed = await _voice.captureAndParse();
    emit(state.copyWith(
        draft: _merge(state.draft, parsed),
        source: DraftSource.voice,
        error: null));
  }

  void updateDraft(void Function(ExpenseDraft d) updater) {
    final d = state.draft;
    updater(d);
    emit(state.copyWith(draft: d));
  }

  Future<void> save() async {
    emit(state.copyWith(isSaving: true, error: null));
    final res = await _addExpense(state.draft);
    res.fold(
        (f) => emit(state.copyWith(isSaving: false, error: f.message)),
        (_) => emit(state.copyWith(
            isSaving: false,
            draft:
                ExpenseDraft(expenseDate: DateTime.now(), currency: 'PKR'))));
  }

  ExpenseDraft _merge(ExpenseDraft base, ExpenseDraft parsed) => ExpenseDraft(
        merchant: parsed.merchant ?? base.merchant,
        amount: parsed.amount ?? base.amount,
        currency: parsed.currency.isNotEmpty ? parsed.currency : base.currency,
        expenseDate: parsed.expenseDate ?? base.expenseDate,
        note: parsed.note ?? base.note,
        categoryId: parsed.categoryId ?? base.categoryId,
      );
}
