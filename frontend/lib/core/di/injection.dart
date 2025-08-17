import 'package:frontend/features/expense/data/datasource/local_datasource.dart';
import 'package:frontend/features/expense/data/datasource/ocr_datasource.dart';
import 'package:frontend/features/expense/data/datasource/voice_datasource.dart';
import 'package:frontend/features/expense/presentation/cubits/add_expense_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/expense/data/datasource/remote_datasource.dart';
import 'package:frontend/features/expense/data/repository/repository_implementation.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';
import 'package:frontend/features/expense/domain/usecase/add_expense.dart';
import 'package:frontend/features/expense/domain/usecase/get_expenses.dart';
import 'package:frontend/features/expense/presentation/cubits/expenses_list_cubit.dart';

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
  setupDataSources();

  // Repositories
  setupRepositories();

  // Use cases
  setupUseCases();

  // Cubits
  setupCubits();
}

void setupDataSources() {
  // Expenses
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
      () => InMemoryExpenseLocalDataSource());
  getIt.registerLazySingleton<OCRDataSource>(() => OCRDataSourceFake());
  getIt.registerLazySingleton<VoiceDataSource>(() => VoiceDataSourceFake());
  getIt.registerLazySingleton<AbstarctRemoteDataSource>(
    () => RemoteDataSourceFake(),
    // () => RemoteDataSource(),
  );
  // Categories
}

void setupRepositories() {
  // Expenses
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
        getIt<ExpenseLocalDataSource>(),
        getIt<OCRDataSource>(),
        getIt<VoiceDataSource>(),
        getIt<AbstarctRemoteDataSource>()),
  );
  // Categories
}

void setupUseCases() {
  // Expenses
  getIt.registerLazySingleton<AddExpense>(
    () => AddExpense(getIt<ExpenseRepository>()),
  );
  getIt.registerLazySingleton<GetExpenses>(
    () => GetExpenses(getIt<ExpenseRepository>()),
  );
}

void setupCubits() {
  // Expenses
  getIt.registerFactory<ExpensesListCubit>(
    () => ExpensesListCubit(
      getIt<GetExpenses>(),
    ),
  );
  getIt.registerFactory<AddExpenseCubit>(
    () => AddExpenseCubit(
      getIt<AddExpense>(),
      getIt<OCRDataSource>(),
      getIt<VoiceDataSource>(),
    ),
  );
  // Categories
}
