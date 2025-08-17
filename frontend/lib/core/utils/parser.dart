import 'package:intl/intl.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';

class ParseHelpers {
  static double? tryParseAmount(String text) {
    final rx = RegExp(r"(\d{1,3}(?:,\d{3})*(?:\.\d+)?)");
    final m = rx.firstMatch(text);
    if (m == null) return null;
    final n = m.group(1)!.replaceAll(',', '');
    return double.tryParse(n);
  }

  static DateTime? tryParseDate(String text) {
    // Extend with intl parsing or patterns: today, yesterday, dd/mm/yyyy
    final now = DateTime.now();
    if (text.toLowerCase().contains('today')) return now;
    return null;
  }
}

class ReceiptParser {
  static final _amountRegex = RegExp(r'(\d{1,3}(?:,\d{3})*(?:\.\d+)?)');
  static final _currencyRegex =
      RegExp(r'\b(PKR|USD|EUR|Rupees?|Rs\.?)\b', caseSensitive: false);
  static final _merchantRegex = RegExp(
      r'(Merchant:\s*(.+))|at\s+([A-Za-z0-9 &\-]+)',
      caseSensitive: false);
  static final _dateRegex = RegExp(
      r'(\d{4}-\d{2}-\d{2})|(\d{1,2}/\d{1,2}/\d{2,4})|\b(today|yesterday)\b',
      caseSensitive: false);

  static ExpenseDraft parse(String raw) {
    final draft = ExpenseDraft();

    // amount
    final am = _amountRegex.firstMatch(raw);
    if (am != null) {
      draft.amount = double.tryParse(am.group(1)!.replaceAll(',', ''));
    }

    // currency
    final cur = _currencyRegex.firstMatch(raw);
    if (cur != null) {
      final v = cur.group(0)!.toUpperCase();
      draft.currency = (v.startsWith('RS') || v.contains('RUPEE')) ? 'PKR' : v;
    }

    // merchant
    final mm = _merchantRegex.firstMatch(raw);
    if (mm != null) {
      draft.merchant = (mm.group(2) ?? mm.group(3))?.trim();
    }

    // date
    final dm = _dateRegex.firstMatch(raw);
    if (dm != null) {
      final token = dm.group(0)!.toLowerCase();
      DateTime? d;
      if (token == 'today') {
        d = DateTime.now();
      } else if (token == 'yesterday') {
        d = DateTime.now().subtract(const Duration(days: 1));
      } else if (token.contains('-') || token.contains('/')) {
        try {
          d = DateTime.tryParse(token) ??
              DateFormat('dd/MM/yy').parseLoose(token, true).toLocal();
        } catch (_) {}
      }
      draft.expenseDate = d ?? DateTime.now();
    } else {
      draft.expenseDate = DateTime.now();
    }

    return draft;
  }
}
