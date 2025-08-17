import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/expense/domain/entity/category.dart';
import 'package:frontend/features/expense/domain/usecase/category_add.dart';
import 'package:frontend/features/expense/domain/usecase/category_get_all.dart';

sealed class CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> items;
  CategoriesLoaded(this.items);
}

class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError(this.message);
}

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategories _getCategories;
  final AddCategory _createCategory;
  CategoriesCubit(this._getCategories, this._createCategory)
      : super(CategoriesLoading());

  Future<void> load() async {
    emit(CategoriesLoading());
    final res = await _getCategories();
    res.fold((f) => emit(CategoriesError(f.message)),
        (items) => emit(CategoriesLoaded(items)));
  }

  Future<void> create(Category category) async {
    final res = await _createCategory(category);
    res.fold((f) => emit(CategoriesError(f.message)), (_) => load());
  }
}
