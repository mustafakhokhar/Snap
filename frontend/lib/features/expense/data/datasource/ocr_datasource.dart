import 'package:frontend/core/utils/parser.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';

abstract class OCRDataSource {
  Future<ExpenseDraft> parseExpenseFromImage(Object imageLike);
}

class OCRDataSourceFake implements OCRDataSource {
  @override
  Future<ExpenseDraft> parseExpenseFromImage(Object imageLike) async {
    // stubbed demo text; integrate ML Kit later
    const raw = 'Merchant: Cafe Z\nTotal: 1250.00 PKR\nDate: 2025-08-15';
    return ReceiptParser.parse(raw);
  }

  // @override
  // Future<ExpenseDraft> parseExpenseFromImage() async {
  //   // Pretend OCR detected these
  //   return ExpenseDraft(
  //       amount: 1250.0,
  //       merchant: 'Cafe Z',
  //       expenseDate: DateTime.now(),
  //       currency: 'PKR',
  //       note: 'Receipt (stubbed)');
  // }
}
