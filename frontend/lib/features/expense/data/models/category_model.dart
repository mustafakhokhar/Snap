import 'package:frontend/features/expense/domain/entity/category.dart';

class CategoryModel {
  final String id;
  final String name;
  final String color;
  final String emoji;
  final String description;
  final DateTime createdAt;
  CategoryModel(
      {required this.id,
      required this.name,
      required this.color,
      required this.emoji,
      required this.description,
      required this.createdAt});

  Category toEntity() => Category(
      id: id,
      name: name,
      color: color,
      createdAt: createdAt,
      emoji: emoji,
      description: description);
}
