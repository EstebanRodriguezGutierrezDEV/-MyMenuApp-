class Recipe {
  final String title;
  final String imageUrl;
  final String difficulty;
  final String time;
  final String description;
  final String calories;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.difficulty,
    required this.time,
    required this.description,
    required this.calories,
    required this.ingredients,
  });
}
