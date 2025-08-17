import 'package:frontend/features/expense/domain/entity/expense.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final DateTime createdAt;
  final String currency;
  final String categoryId;
  final String merchant;
  final String note;
  final String paymentMethod;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
    required this.currency,
    required this.categoryId,
    required this.merchant,
    required this.note,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'currency': currency,
      'categoryId': categoryId,
      'merchant': merchant,
      'note': note,
      'paymentMethod': paymentMethod,
    };
  }

  Expense toEntity() => Expense(
        id: id,
        title: title,
        amount: amount,
        currency: currency,
        expenseDate: createdAt,
        categoryId: categoryId,
        merchant: merchant,
        note: note,
        paymentMethod: paymentMethod,
        createdAt: createdAt,
      );

  static ExpenseModel fromDraft(ExpenseDraft d) => ExpenseModel(
        id: '',
        amount: d.amount ?? 0,
        currency: d.currency,
        categoryId: d.categoryId ?? '',
        title: d.title ?? '',
        merchant: d.merchant ?? '',
        note: d.note ?? '',
        paymentMethod: d.paymentMethod ?? '',
        createdAt: DateTime.now(),
      );
}

// class ExpenseModel extends Expense {
//   ExpenseModel({
//     required String id,
//     required String title,
//     required double amount,
//     required DateTime date,
//     required String currency,
//     required String? categoryId,
//     required String? merchant,
//     required String? note,
//   }) : super(
//             id: id,
//             title: title,
//             amount: amount,
//             currency: currency,
//             date: date,
//             categoryId: categoryId,
//             merchant: merchant,
//             note: note);

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'amount': amount,
//       'date': date.toIso8601String(),
//     };
//   }

//   factory ExpenseModel.fromEntity(Expense expense) {
//     return ExpenseModel(
//         id: expense.id,
//         title: expense.title,
//         amount: expense.amount,
//         currency: expense.currency,
//         date: expense.date,
//         categoryId: expense.categoryId,
//         merchant: expense.merchant,
//         note: expense.note);
//   }

//   Expense toEntity() {
//     return Expense(
//       id: id,
//       title: title,
//       amount: amount,
//       currency: currency,
//       date: date,
//       categoryId: categoryId,
//       merchant: merchant,
//       note: note,
//     );
//   }
// }
