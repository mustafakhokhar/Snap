class Category {
  final String id;
  final String name;
  final String color;
  final String emoji;
  final String description;
  final DateTime createdAt;
  Category(
      {required this.id,
      required this.name,
      required this.color,
      required this.emoji,
      required this.description,
      required this.createdAt});
}
