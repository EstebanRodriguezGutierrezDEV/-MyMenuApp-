import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/recipe_service.dart';
import 'models/recipe_model.dart';
import 'widgets/social_recipe_post.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final _recipeService = RecipeService();
  late Future<List<Recipe>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _recipeService.getFeedRecipes();
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _feedFuture = _recipeService.getFeedRecipes();
    });
    await _feedFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      body: Column(
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 20,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Recetas',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Social Feed
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshFeed,
              child: FutureBuilder<List<Recipe>>(
                future: _feedFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final recipes = snapshot.data ?? [];
                  if (recipes.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay recetas aún. ¡Sé el primero!',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      // Mock user data cycle (until we have user profiles)
                      final users = [
                        {
                          'name': 'Ana Cocina',
                          'img': 'https://i.pravatar.cc/150?u=ana',
                        },
                        {
                          'name': 'Green Foodie',
                          'img': 'https://i.pravatar.cc/150?u=green',
                        },
                        {
                          'name': 'Chef Mario',
                          'img': 'https://i.pravatar.cc/150?u=mario',
                        },
                      ];
                      final user = users[index % users.length];

                      return SocialRecipePost(
                        recipe: recipes[index],
                        username: user['name']!,
                        userAvatarUrl: user['img']!,
                        initialLikes: 0, // We let the service fetch real likes
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
