import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:frontend/features/expense/presentation/cubits/add_expense_cubit.dart';
import 'package:frontend/features/expense/presentation/cubits/expenses_list_cubit.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountCtrl = TextEditingController();
  final _merchantCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  // You don't have categories yet; keep a simple local dropdown or text.
  String? _categoryId; // optional
  DateTime _selectedDate = DateTime.now();
  String _paymentMethod = 'cash'; // cash | card | wallet

  @override
  void initState() {
    super.initState();
    // Don’t touch Bloc in initState synchronously. Defer to next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final add = _maybeAddCubit(context);
      if (add == null) return;
      final d = add.state.draft; // draft should exist in your implementation
      // Defensive population (don’t assume non-null fields)
      setState(() {
        _amountCtrl.text = (d.amount != null) ? d.amount!.toString() : '';
        _merchantCtrl.text = d.merchant ?? '';
        _noteCtrl.text = d.note ?? '';
        _categoryId = d.categoryId; // still optional
        _selectedDate = d.expenseDate ?? DateTime.now();
        _paymentMethod =
            (d.paymentMethod?.isNotEmpty ?? false) ? d.paymentMethod! : 'cash';
      });
    });
  }

  AddExpenseCubit? _maybeAddCubit(BuildContext ctx) {
    try {
      return ctx.read<AddExpenseCubit>();
    } catch (_) {
      // Not found in the tree — you’ll see a warning in logs.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addCubit = _maybeAddCubit(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: BlocListener<AddExpenseCubit, AddExpenseState>(
        listenWhen: (prev, next) =>
            prev.isSaving != next.isSaving || prev.error != next.error,
        listener: (context, state) async {
          if (!state.isSaving) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Expense added successfully!'),
                    backgroundColor: Colors.green),
              );
            }
            // Optional: refresh list if present
            try {
              final list = context.read<ExpensesListCubit>();
              await list.refresh();
            } catch (_) {}
            if (mounted) Navigator.of(context).maybePop();
          } else if (!state.isSaving && state.error != null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.error}'),
                    backgroundColor: Colors.red),
              );
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Optional quick-fill actions (safe if cubit exists)
                if (addCubit != null)
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await addCubit.scanReceipt(
                              Object()); // plug image_picker File later
                          final d = addCubit.state.draft;
                          setState(() {
                            _amountCtrl.text =
                                d.amount?.toString() ?? _amountCtrl.text;
                            _merchantCtrl.text =
                                d.merchant ?? _merchantCtrl.text;
                            _noteCtrl.text = d.note ?? _noteCtrl.text;
                            _categoryId = d.categoryId ?? _categoryId;
                            _selectedDate = d.expenseDate ?? _selectedDate;
                            _paymentMethod =
                                (d.paymentMethod?.isNotEmpty ?? false)
                                    ? d.paymentMethod!
                                    : _paymentMethod;
                          });
                        },
                        icon: const Icon(Icons.document_scanner),
                        label: const Text('Receipt'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () async {
                          await addCubit.voiceCapture();
                          final d = addCubit.state.draft;
                          setState(() {
                            _amountCtrl.text =
                                d.amount?.toString() ?? _amountCtrl.text;
                            _merchantCtrl.text =
                                d.merchant ?? _merchantCtrl.text;
                            _noteCtrl.text = d.note ?? _noteCtrl.text;
                            _categoryId = d.categoryId ?? _categoryId;
                            _selectedDate = d.expenseDate ?? _selectedDate;
                            _paymentMethod =
                                (d.paymentMethod?.isNotEmpty ?? false)
                                    ? d.paymentMethod!
                                    : _paymentMethod;
                          });
                        },
                        icon: const Icon(Icons.mic),
                        label: const Text('Voice'),
                      ),
                    ],
                  ),

                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter an amount';
                    final amount = double.tryParse(value.replaceAll(',', ''));
                    if (amount == null || amount <= 0)
                      return 'Please enter a valid amount';
                    return null;
                  },
                  onChanged: (v) => addCubit?.updateDraft(
                      (d) => d.amount = double.tryParse(v.replaceAll(',', ''))),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _merchantCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Merchant / Title',
                    hintText: 'e.g., Cafe Z',
                    prefixIcon: Icon(Icons.store),
                  ),
                  onChanged: (v) =>
                      addCubit?.updateDraft((d) => d.merchant = v.trim()),
                ),

                const SizedBox(height: 16),
                // Minimal “category” until your feature is ready:
                TextFormField(
                  initialValue: _categoryId ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Category (optional)',
                    hintText: 'e.g., Food',
                    prefixIcon: Icon(Icons.category),
                  ),
                  onChanged: (v) {
                    setState(() =>
                        _categoryId = (v.trim().isEmpty ? null : v.trim()));
                    addCubit?.updateDraft((d) => d.categoryId = _categoryId);
                  },
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Add a note',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  onChanged: (v) =>
                      addCubit?.updateDraft((d) => d.note = v.trim()),
                ),

                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _pickDate,
                ),

                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'card', child: Text('Card')),
                    DropdownMenuItem(value: 'wallet', child: Text('Wallet')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _paymentMethod = v);
                    addCubit?.updateDraft((d) => d.paymentMethod = v);
                  },
                ),

                const SizedBox(height: 24),
                BlocBuilder<AddExpenseCubit, AddExpenseState>(
                  builder: (_, state) {
                    return ElevatedButton(
                      onPressed: state.isSaving ? null : _submitForm,
                      child: state.isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white)),
                            )
                          : const Text('Add Expense'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final addCubit = _maybeAddCubit(context);
    if (addCubit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('AddExpenseCubit not found in context'),
            backgroundColor: Colors.red),
      );
      return;
    }

    addCubit.updateDraft((d) {
      d.amount = double.tryParse(_amountCtrl.text.replaceAll(',', ''));
      d.merchant =
          _merchantCtrl.text.trim().isEmpty ? null : _merchantCtrl.text.trim();
      d.note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();
      d.categoryId = _categoryId;
      d.expenseDate = _selectedDate;
      d.paymentMethod = _paymentMethod;
      d.currency = d.currency.isEmpty ? 'PKR' : d.currency;
    });

    await addCubit.save();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _maybeAddCubit(context)?.updateDraft((d) => d.expenseDate = picked);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _merchantCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }
}
