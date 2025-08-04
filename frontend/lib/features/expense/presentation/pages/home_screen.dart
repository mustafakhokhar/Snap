import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/expense/domain/entity/expense.dart';
import 'package:frontend/features/expense/presentation/cubits/expense_cubit.dart';
import 'package:frontend/features/expense/presentation/widgets/expense_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPeriod = 'today';

  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().loadExpenses(period: selectedPeriod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ExpenseSuccess) {
            return _buildExpenseList(state.expenses);
          } else if (state is ExpenseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ExpenseCubit>()
                          .loadExpenses(period: selectedPeriod);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('No expenses found'));
        },
      ),
    );
  }

  Widget _buildExpenseList(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No expenses found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Add your first expense to get started!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return ExpenseCard(expense: expenses[index]);
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Expenses'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Today'),
              value: 'today',
              groupValue: selectedPeriod,
              onChanged: (value) {
                setState(() {
                  selectedPeriod = value!;
                });
                Navigator.pop(context);
                context
                    .read<ExpenseCubit>()
                    .loadExpenses(period: selectedPeriod);
              },
            ),
            RadioListTile<String>(
              title: Text('This Week'),
              value: 'week',
              groupValue: selectedPeriod,
              onChanged: (value) {
                setState(() {
                  selectedPeriod = value!;
                });
                Navigator.pop(context);
                context
                    .read<ExpenseCubit>()
                    .loadExpenses(period: selectedPeriod);
              },
            ),
            RadioListTile<String>(
              title: Text('This Month'),
              value: 'month',
              groupValue: selectedPeriod,
              onChanged: (value) {
                setState(() {
                  selectedPeriod = value!;
                });
                Navigator.pop(context);
                context
                    .read<ExpenseCubit>()
                    .loadExpenses(period: selectedPeriod);
              },
            ),
          ],
        ),
      ),
    );
  }
}
