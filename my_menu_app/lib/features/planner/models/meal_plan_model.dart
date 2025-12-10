class MealPlan {
  final String? id;
  final String userId;
  final String? recipeId;
  final DateTime date;
  final String mealType; // 'lunch' or 'dinner'
  final Map<String, dynamic>? recipe; // Joined recipe data

  MealPlan({
    this.id,
    required this.userId,
    this.recipeId,
    required this.date,
    required this.mealType,
    this.recipe,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      date: DateTime.parse(json['date']),
      mealType: json['meal_type'],
      recipe: json['recipes'], // Supabase join returns 'recipes' key
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'recipe_id': recipeId,
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'meal_type': mealType,
    };
  }
}
