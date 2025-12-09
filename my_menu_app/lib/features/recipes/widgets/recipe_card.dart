import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/recipe_model.dart';
import '../recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with Hero
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'recipe_image_${recipe.title}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: recipe.imageUrl.startsWith('http')
                      ? Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[300]),
                        )
                      : Image.asset(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[300]),
                        ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A313A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                              recipe.difficulty,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            recipe.difficulty,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getDifficultyColor(recipe.difficulty),
                            ),
                          ),
                        ),
                        Text(
                          '⏱ ${recipe.time}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      recipe.calories,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 24.3, // Reduced by 7.7 pixels (32 - 7.7)
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Ver Receta',
                          style: GoogleFonts.inter(
                            fontSize: 11, // Reduced font size
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'medio':
        return Colors.orange;
      case 'difícil':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
