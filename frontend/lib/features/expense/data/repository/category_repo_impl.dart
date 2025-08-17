import 'package:frontend/core/utils/errors.dart';
import 'package:frontend/core/utils/result.dart';
import 'package:frontend/features/expense/data/datasource/remote_datasource.dart';
import 'package:frontend/features/expense/data/models/category_model.dart';
import 'package:frontend/features/expense/domain/entity/category.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AbstarctRemoteDataSource remoteDataSource;
  CategoryRepositoryImpl(this.remoteDataSource);
  @override
  Future<Result<List<Category>>> getAll() async {
    try {
      final models = await remoteDataSource.getCategories();
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(Failure('Failed to load categories', cause: e));
    }
  }

  @override
  Future<Result<Category>> add(Category category) async {
    try {
      final model = CategoryModel(
        id: category.id,
        name: category.name,
        color: category.color,
        emoji: category.emoji,
        description: category.description,
        createdAt: category.createdAt,
      );
      final saved = await remoteDataSource.addCategory(model);
      return Ok(saved.toEntity());
    } catch (e) {
      return Err(Failure('Failed to add category', cause: e));
    }
  }
}
