class Recipe {
  final String? id; // Database ID (null for new recipes before upload)
  final String title;
  final String imageUrl;
  final String difficulty;
  final String time;
  final String description;
  final String calories;
  final List<String> ingredients;

  Recipe({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.difficulty,
    required this.time,
    required this.description,
    required this.calories,
    required this.ingredients,
  });
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'image_url': imageUrl,
      'difficulty': difficulty,
      'time': time,
      'description': description,
      'calories': calories,
      'ingredients': ingredients,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'] ?? '',
      imageUrl: map['image_url'] ?? '',
      difficulty: map['difficulty'] ?? '',
      time: map['time'] ?? '',
      description: map['description'] ?? '',
      calories: map['calories'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
    );
  }
}
