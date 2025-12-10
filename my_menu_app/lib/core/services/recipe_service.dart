import '../../features/recipes/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch "My Uploaded Recipes"
  Future<List<Recipe>> getMyUploadedRecipes() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('recipes')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Recipe.fromJson(e)).toList();
  }

  // Fetch "Liked Recipes"
  Future<List<Recipe>> getLikedRecipes() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    // Select recipes through the likes junction table
    final response = await _supabase
        .from('likes')
        .select('recipes(*)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    // Response structure is [{recipes: {id: ..., title: ...}}, ...]
    return (response as List)
        .map((e) => Recipe.fromJson(e['recipes']))
        .toList();
  }

  // Fetch "Saved Recipes"
  Future<List<Recipe>> getSavedRecipes() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('saved_recipes')
        .select('recipes(*)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => Recipe.fromJson(e['recipes']))
        .toList();
  }

  // Create a new recipe (Real implementation)
  Future<void> createRecipe(Recipe recipe) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('recipes').insert({
      ...recipe.toJson(),
      'user_id': user.id,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
