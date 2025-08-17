import 'package:frontend/core/utils/parser.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';

abstract class VoiceDataSource {
  Future<ExpenseDraft> captureAndParse();
}

class VoiceDataSourceFake implements VoiceDataSource {
  @override
  Future<ExpenseDraft> captureAndParse() async {
    // imagine microphone captured this:
    const transcript = 'Lunch 1250 rupees at Cafe Z today cash';
    return ReceiptParser.parse(transcript);
  }

  // @override
  // Future<ExpenseDraft> captureAndParse() async {
  //   // Pretend STT parsed this sentence: "Lunch 900 at Nandos today"
  //   return ExpenseDraft(
  //       amount: 900.0,
  //       merchant: 'Nandos',
  //       expenseDate: DateTime.now(),
  //       currency: 'PKR',
  //       note: 'Voice (stubbed)');
  // }
}
