// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/features/expense/domain/entity/expense.dart';
// import 'package:frontend/features/expense/presentation/cubits/expenses_list_cubit.dart';
// import 'package:uuid/uuid.dart';

// class AddExpenseScreen extends StatefulWidget {
//   @override
//   _AddExpenseScreenState createState() => _AddExpenseScreenState();
// }

// class _AddExpenseScreenState extends State<AddExpenseScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String _selectedCategory = 'Food';
//   DateTime _selectedDate = DateTime.now();

//   final List<String> _categories = [
//     'Food',
//     'Transport',
//     'Shopping',
//     'Entertainment',
//     'Health',
//     'Utilities',
//     'Other',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Expense'),
//       ),
//       body: BlocListener<ExpenseCubit, ExpenseState>(
//         listener: (context, state) {
//           if (state is AddExpenseSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Expense added successfully!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             _resetForm();
//           } else if (state is AddExpenseError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Error: ${state.message}'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   controller: _titleController,
//                   decoration: InputDecoration(
//                     labelText: 'Title',
//                     hintText: 'Enter expense title',
//                     prefixIcon: Icon(Icons.title),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter a title';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _amountController,
//                   decoration: InputDecoration(
//                     labelText: 'Amount',
//                     hintText: '0.00',
//                     prefixIcon: Icon(Icons.attach_money),
//                   ),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter an amount';
//                     }
//                     final amount = double.tryParse(value);
//                     if (amount == null || amount <= 0) {
//                       return 'Please enter a valid amount';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedCategory,
//                   decoration: InputDecoration(
//                     labelText: 'Category',
//                     prefixIcon: Icon(Icons.category),
//                   ),
//                   items: _categories.map((category) {
//                     return DropdownMenuItem(
//                       value: category,
//                       child: Text(category),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCategory = value!;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _descriptionController,
//                   decoration: InputDecoration(
//                     labelText: 'Description (Optional)',
//                     hintText: 'Enter description',
//                     prefixIcon: Icon(Icons.description),
//                   ),
//                   maxLines: 3,
//                 ),
//                 SizedBox(height: 16),
//                 ListTile(
//                   leading: Icon(Icons.calendar_today),
//                   title: Text('Date'),
//                   subtitle: Text(
//                     '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
//                   ),
//                   trailing: Icon(Icons.arrow_forward_ios),
//                   onTap: _selectDate,
//                 ),
//                 SizedBox(height: 32),
//                 BlocBuilder<ExpenseCubit, ExpenseState>(
//                   builder: (context, state) {
//                     return ElevatedButton(
//                       onPressed:
//                           state is AddExpenseLoading ? null : _submitForm,
//                       child: state is AddExpenseLoading
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text('Adding...'),
//                               ],
//                             )
//                           : Text('Add Expense'),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final expense = Expense(
//         id: Uuid().v4(),
//         name: 'User', // TODO: Get from user profile
//         title: _titleController.text.trim(),
//         amount: double.parse(_amountController.text),
//         expenseDate: _selectedDate,
//         category: _selectedCategory,
//         description: _descriptionController.text.trim(),
//       );

//       context.read<ExpenseCubit>().submitExpense(expense);
//     }
//   }

//   void _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now().add(Duration(days: 1)),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   void _resetForm() {
//     _titleController.clear();
//     _amountController.clear();
//     _descriptionController.clear();
//     setState(() {
//       _selectedCategory = 'Food';
//       _selectedDate = DateTime.now();
//     });
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _amountController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }
