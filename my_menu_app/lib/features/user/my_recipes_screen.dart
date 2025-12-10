import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/recipe_service.dart';
import '../recipes/models/recipe_model.dart';

class MyRecipesScreen extends StatelessWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F5),
        appBar: AppBar(
          title: Text(
            'Mis Recetas',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            tabs: const [
              Tab(text: 'Subidas'),
              Tab(text: 'Me Gusta'),
              Tab(text: 'Guardadas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _RecipeList(type: RecipeListType.uploaded),
            _RecipeList(type: RecipeListType.liked),
            _RecipeList(type: RecipeListType.saved),
          ],
        ),
      ),
    );
  }
}

enum RecipeListType { uploaded, liked, saved }

class _RecipeList extends StatefulWidget {
  final RecipeListType type;
  const _RecipeList({required this.type});

  @override
  State<_RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<_RecipeList> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<Recipe>> _loadRecipes;

  @override
  void initState() {
    super.initState();
    _loadRecipes = _fetchRecipes();
  }

  Future<List<Recipe>> _fetchRecipes() {
    switch (widget.type) {
      case RecipeListType.uploaded:
        return _recipeService.getMyUploadedRecipes();
      case RecipeListType.liked:
        return _recipeService.getLikedRecipes();
      case RecipeListType.saved:
        return _recipeService.getSavedRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: _loadRecipes,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay recetas aquí aún',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return _RecipeCard(recipe: recipes[index]);
          },
        );
      },
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              image: DecorationImage(
                image: recipe.imageUrl.startsWith('http')
                    ? NetworkImage(recipe.imageUrl)
                    : AssetImage(recipe.imageUrl) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF1A313A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.time,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.whatshot, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        recipe.calories,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Arrow
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
