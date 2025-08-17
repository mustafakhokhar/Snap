import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final double amount;
  final String title;
  final String currency;
  final DateTime expenseDate;
  final DateTime createdAt;
  final String categoryId;
  final String merchant;
  final String paymentMethod;
  final String? note;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.expenseDate,
    required this.categoryId,
    required this.merchant,
    required this.paymentMethod,
    required this.createdAt,
    required this.note,
  });

  @override
  List<Object?> get props =>
      [id, amount, currency, expenseDate, categoryId, merchant, note];
}

class ExpenseDraft {
  double? amount;
  String? title;
  String? merchant;
  String currency;
  DateTime? expenseDate;
  String? note;
  String? categoryId;
  String? paymentMethod;
  ExpenseDraft(
      {this.merchant,
      this.amount,
      this.title,
      this.currency = 'PKR',
      this.expenseDate,
      this.note,
      this.categoryId,
      this.paymentMethod});

  ExpenseDraft copyWith({
    double? amount,
    String? currency,
    DateTime? expenseDate,
    String? categoryId,
    String? merchant,
    String? note,
    String? paymentMethod,
    String? title,
  }) {
    return ExpenseDraft(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      expenseDate: expenseDate ?? this.expenseDate,
      categoryId: categoryId ?? this.categoryId,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      paymentMethod: (paymentMethod ?? this.paymentMethod),
      title: title ?? this.title,
    );
  }
}
