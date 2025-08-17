import 'package:frontend/features/expense/data/datasource/ocr_datasource.dart';
import 'package:frontend/features/expense/data/datasource/voice_datasource.dart';
import 'package:frontend/features/expense/data/repository/category_repo_impl.dart';
import 'package:frontend/features/expense/domain/usecase/category_add.dart';
import 'package:frontend/features/expense/domain/usecase/category_get_all.dart';
import 'package:frontend/features/expense/presentation/cubits/add_expense_cubit.dart';
import 'package:frontend/features/expense/presentation/cubits/categories_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/expense/data/datasource/remote_datasource.dart';
import 'package:frontend/features/expense/data/repository/expense_repo_impl.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';
import 'package:frontend/features/expense/domain/usecase/expense_add.dart';
import 'package:frontend/features/expense/domain/usecase/expenses_get.dart';
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
    () => ExpenseRepositoryImpl(getIt<OCRDataSource>(),
        getIt<VoiceDataSource>(), getIt<AbstarctRemoteDataSource>()),
  );
  // Categories
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<AbstarctRemoteDataSource>()),
  );
}

void setupUseCases() {
  // Expenses
  getIt.registerLazySingleton<AddExpense>(
    () => AddExpense(getIt<ExpenseRepository>()),
  );
  getIt.registerLazySingleton<GetExpenses>(
    () => GetExpenses(getIt<ExpenseRepository>()),
  );
  // Categories
  getIt.registerLazySingleton<GetCategories>(
    () => GetCategories(getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<AddCategory>(
    () => AddCategory(getIt<CategoryRepository>()),
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
  getIt.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(
      getIt<GetCategories>(),
      getIt<AddCategory>(),
    ),
  );
}
