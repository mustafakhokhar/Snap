import 'package:frontend/core/utils/result.dart';
import 'package:frontend/features/expense/domain/entity/category.dart';
import 'package:frontend/features/expense/domain/repository/repository_interface.dart';

class GetCategories {
  final CategoryRepository repo;
  GetCategories(this.repo);
  Future<Result<List<Category>>> call() => repo.getAll();
}