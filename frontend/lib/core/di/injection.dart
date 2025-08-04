import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/expense/data/datasource/remote_datasource.dart';
import 'package:frontend/features/expense/data/repository/expense_repo_impl.dart';
import 'package:frontend/features/expense/domain/repository/expense_repo.dart';
import 'package:frontend/features/expense/domain/usecase/add_expense.dart';
import 'package:frontend/features/expense/domain/usecase/get_expenses.dart';
import 'package:frontend/features/expense/presentation/cubits/expense_cubit.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core dependencies
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = 'https://your-api-base-url.com/api';
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 30);
    return dio;
  });

  // Data sources
  getIt.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(getIt<ExpenseRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<AddExpense>(
    () => AddExpense(getIt<ExpenseRepository>()),
  );

  getIt.registerLazySingleton<GetExpenses>(
    () => GetExpenses(getIt<ExpenseRepository>()),
  );

  // Cubits
  getIt.registerFactory<ExpenseCubit>(
    () => ExpenseCubit(
      addExpense: getIt<AddExpense>(),
      getExpenses: getIt<GetExpenses>(),
    ),
  );
}
