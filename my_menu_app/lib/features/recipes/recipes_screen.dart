import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/recipes_data.dart';
import 'widgets/social_recipe_post.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedRecipes.length,
              itemBuilder: (context, index) {
                // Mock data cycle
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
                    'name': 'Carlos Cooks',
                    'img': 'https://i.pravatar.cc/150?u=carlos',
                  },
                ];
                final user = users[index % users.length];

                return SocialRecipePost(
                  recipe: feedRecipes[index],
                  username: user['name']!,
                  userAvatarUrl: user['img']!,
                  initialLikes: (index * 33) % 500 + 10,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
