import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/planner/models/meal_plan_model.dart';
import '../../features/recipes/models/recipe_model.dart';

class MealPlanService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get plans for a specific date range (usually a week)
  Future<List<MealPlan>> getWeeklyPlan(
    DateTime startOfWeek,
    DateTime endOfWeek,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('meal_plans')
        .select('*, recipes(*)')
        .eq('user_id', user.id)
        .gte('date', startOfWeek.toIso8601String().split('T')[0])
        .lte('date', endOfWeek.toIso8601String().split('T')[0]);

    return (response as List).map((e) => MealPlan.fromJson(e)).toList();
  }

  // Save (Upsert) a plan
  Future<void> savePlan(MealPlan plan) async {
    await _supabase.from('meal_plans').upsert(plan.toJson());
  }

  // Generate Smart Plan
  Future<List<MealPlan>> generateSmartPlan(DateTime startOfWeek) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    // 1. Fetch Fridge Items
    final fridgeResponse = await _supabase
        .from('fridge_items')
        .select('name')
        .eq('user_id', user.id);

    final List<String> fridgeItems = (fridgeResponse as List)
        .map((e) => (e['name'] as String).toLowerCase())
        .toList();

    if (fridgeItems.isEmpty) return [];

    // 2. Fetch All Recipes
    final recipesResponse = await _supabase.from('recipes').select();

    final List<Recipe> allRecipes = (recipesResponse as List)
        .map((e) => Recipe.fromJson(e))
        .toList();

    // 3. Score Recipes
    // Simple algorithm: Score = number of matching ingredients
    final List<Map<String, dynamic>> scoredRecipes = [];

    for (var recipe in allRecipes) {
      int matchCount = 0;
      for (var ingredient in recipe.ingredients) {
        // Basic substring match
        bool hasIngredient = fridgeItems.any(
          (item) =>
              ingredient.toLowerCase().contains(item) ||
              item.contains(ingredient.toLowerCase()),
        );
        if (hasIngredient) matchCount++;
      }

      if (matchCount > 0) {
        scoredRecipes.add({'recipe': recipe, 'score': matchCount});
      }
    }

    // Sort by score descending
    scoredRecipes.sort(
      (a, b) => (b['score'] as int).compareTo(a['score'] as int),
    );

    // 4. Create Plan Suggestion (Fill empty slots for next 7 days)
    final List<MealPlan> suggestedPlan = [];
    final existingPlans = await getWeeklyPlan(
      startOfWeek,
      startOfWeek.add(const Duration(days: 6)),
    );

    int recipeIndex = 0;

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateStr = date.toIso8601String().split('T')[0];

      // Check Lunch
      bool hasLunch = existingPlans.any(
        (p) =>
            p.date.toIso8601String().split('T')[0] == dateStr &&
            p.mealType == 'lunch',
      );

      if (!hasLunch && recipeIndex < scoredRecipes.length) {
        final recipe = scoredRecipes[recipeIndex]['recipe'] as Recipe;
        suggestedPlan.add(
          MealPlan(
            userId: user.id,
            recipeId: recipe.id,
            date: date,
            mealType: 'lunch',
            recipe: recipe.toJson(), // Embed for UI preview
          ),
        );
        recipeIndex = (recipeIndex + 1) % scoredRecipes.length;
      }

      // Check Dinner
      bool hasDinner = existingPlans.any(
        (p) =>
            p.date.toIso8601String().split('T')[0] == dateStr &&
            p.mealType == 'dinner',
      );

      if (!hasDinner && recipeIndex < scoredRecipes.length) {
        final recipe = scoredRecipes[recipeIndex]['recipe'] as Recipe;
        suggestedPlan.add(
          MealPlan(
            userId: user.id,
            recipeId: recipe.id,
            date: date,
            mealType: 'dinner',
            recipe: recipe.toJson(),
          ),
        );
        recipeIndex = (recipeIndex + 1) % scoredRecipes.length;
      }
    }

    return suggestedPlan;
  }
}
