import 'package:frontend/core/utils/errors.dart';
import 'package:frontend/core/utils/period.dart';
import 'package:frontend/core/utils/result.dart';
import 'package:frontend/features/expense/data/datasource/ocr_datasource.dart';
import 'package:frontend/features/expense/data/datasource/remote_datasource.dart';
import 'package:frontend/features/expense/data/datasource/voice_datasource.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final AbstarctRemoteDataSource remoteDataSource;
  final OCRDataSource ocr;
  final VoiceDataSource voice;
  ExpenseRepositoryImpl(this.ocr, this.voice, this.remoteDataSource);

  @override
  Future<Result<Expense>> add(ExpenseDraft draft) async {
    try {
      final saved = await remoteDataSource.addExpense(draft);
      return Ok(saved.toEntity());
    } catch (e) {
      return Err(Failure('Failed to add expense', cause: e));
    }
  }

  @override
  Future<Result<List<Expense>>> getByPeriod(Period period) async {
    try {
      final models = await remoteDataSource.getExpenses(period);
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(Failure('Failed to load expenses', cause: e));
    }
  }
}
