import '../../features/recipes/models/recipe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

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

  // Fetch Public Feed Recipes (All recipes for now)
  Future<List<Recipe>> getFeedRecipes() async {
    final response = await _supabase
        .from('recipes')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((e) => Recipe.fromJson(e)).toList();
  }

  // Toggle Like
  Future<void> toggleLike(String recipeId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final isLiked = await isRecipeLiked(recipeId);
    if (isLiked) {
      await _supabase
          .from('likes')
          .delete()
          .eq('recipe_id', recipeId)
          .eq('user_id', user.id);
    } else {
      await _supabase.from('likes').insert({
        'user_id': user.id,
        'recipe_id': recipeId,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // Check if recipe is liked by current user
  Future<bool> isRecipeLiked(String recipeId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('likes')
        .select()
        .eq('recipe_id', recipeId)
        .eq('user_id', user.id)
        .maybeSingle();

    return response != null;
  }

  // Upload Recipe Image
  Future<String?> uploadImage(File imageFile) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final extension = imageFile.path.split('.').last;
      final fileName =
          '${user.id}/${DateTime.now().millisecondsSinceEpoch}.$extension';

      await _supabase.storage.from('recipes').upload(fileName, imageFile);

      return _supabase.storage.from('recipes').getPublicUrl(fileName);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
