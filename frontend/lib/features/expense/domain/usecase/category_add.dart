import 'package:frontend/core/utils/result.dart';
import 'package:frontend/features/expense/domain/entity/category.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';

class AddCategory {
  final CategoryRepository repo;
  AddCategory(this.repo);

  Future<Result<Category>> call(Category category) => repo.add(category);
}
