import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/recipe_model.dart';
import 'data/recipes_data.dart';
import 'widgets/recipe_card.dart';
import 'widgets/recipes_header.dart';

class NewRecipesScreen extends StatefulWidget {
  const NewRecipesScreen({super.key});

  @override
  State<NewRecipesScreen> createState() => _NewRecipesScreenState();
}

class _NewRecipesScreenState extends State<NewRecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe>? _filteredRecipes;

  List<Recipe> get currentRecipes => _filteredRecipes ?? newRecipes;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  _sortByDifficulty(ascending: true);
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
                  _sortByDifficulty(ascending: false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore, color: Colors.grey),
                title: Text('Restaurar orden', style: GoogleFonts.inter()),
                onTap: () {
                  setState(() {
                    _filteredRecipes = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sortByDifficulty({required bool ascending}) {
    final List<Recipe> sortedList = List.from(currentRecipes);
    sortedList.sort((a, b) {
      int weightA = _getDifficultyWeight(a.difficulty);
      int weightB = _getDifficultyWeight(b.difficulty);
      return ascending
          ? weightA.compareTo(weightB)
          : weightB.compareTo(weightA);
    });

    setState(() {
      _filteredRecipes = sortedList;
    });
  }

  int _getDifficultyWeight(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return 1;
      case 'medio':
        return 2;
      case 'difícil':
        return 3;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      body: Column(
        children: [
          RecipesHeader(
            searchController: _searchController,
            onFilterTap: _showFilterOptions,
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: currentRecipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipe: currentRecipes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
