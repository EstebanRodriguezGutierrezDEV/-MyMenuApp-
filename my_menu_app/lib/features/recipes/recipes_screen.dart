import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/recipe_service.dart';
import 'models/recipe_model.dart';
import 'widgets/social_recipe_post.dart';
import 'new_recipes_screen.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>
    with SingleTickerProviderStateMixin {
  final _recipeService = RecipeService();
  late Future<List<Recipe>> _feedFuture;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String? _sortOrder;

  @override
  void initState() {
    super.initState();
    _feedFuture = _recipeService.getFeedRecipes();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    } else {
      // Also update when swipe finishes
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _feedFuture = _recipeService.getFeedRecipes();
    });
    await _feedFuture;
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ordenar por Dificultad',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A313A),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.green),
                title: Text('Más fáciles primero', style: GoogleFonts.inter()),
                onTap: () {
                  setState(() => _sortOrder = 'easy');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.red),
                title: Text(
                  'Más difíciles primero',
                  style: GoogleFonts.inter(),
                ),
                onTap: () {
                  setState(() => _sortOrder = 'hard');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore, color: Colors.grey),
                title: Text('Restaurar orden', style: GoogleFonts.inter()),
                onTap: () {
                  setState(() => _sortOrder = null);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      body: Column(
        children: [
          // Custom Header with TabBar and Search
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Recetas',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  labelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  unselectedLabelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  tabs: const [
                    Tab(text: 'Feed'),
                    Tab(text: 'Buscar'),
                  ],
                ),
                // Search Bar - Animates based on tab position
                AnimatedBuilder(
                  animation: _tabController.animation!,
                  builder: (context, child) {
                    final double value = _tabController.animation!.value;
                    // Ensure value is clamped between 0.0 and 1.0 for opacity
                    final double opacity = value.clamp(0.0, 1.0);
                    // Use Align with heightFactor to animate height from 0 to 1
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: opacity,
                        child: Opacity(opacity: opacity, child: child),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.inter(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: '¿Qué se te antoja?',
                                hintStyle: GoogleFonts.inter(
                                  color: Colors.grey.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: AppColors.primary.withOpacity(0.7),
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _showFilterOptions,
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Social Feed
                RefreshIndicator(
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
                            initialLikes: 0,
                          );
                        },
                      );
                    },
                  ),
                ),

                // Tab 2: New Recipes (Search)
                NewRecipesScreen(
                  searchController: _searchController,
                  sortOrder: _sortOrder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
