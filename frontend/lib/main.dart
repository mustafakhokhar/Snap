import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/expense/data/datasource/remote_datasource.dart';
import 'package:frontend/features/expense/data/repository/expense_repo_impl.dart';
import 'package:frontend/features/expense/domain/usecase/add_expense.dart';

import 'features/expense/presentation/cubits/add_expense_cubit.dart';
import 'features/expense/presentation/pages/add_expense_page.dart';

void main() {
  final remoteDataSource = ExpenseRemoteDataSourceImpl();
  final repository = ExpenseRepositoryImpl(remoteDataSource);
  final addExpense = AddExpense(repository);

  runApp(MyApp(addExpense: addExpense));
}

class MyApp extends StatelessWidget {
  final AddExpense addExpense;
  const MyApp({super.key, required this.addExpense});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => AddExpenseCubit(addExpense),
        child: AddExpensePage(),
      ),
    );
  }
}
