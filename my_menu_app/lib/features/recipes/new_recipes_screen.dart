import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/recipe_model.dart';
import 'data/recipes_data.dart';
import 'widgets/recipe_card.dart';
import 'widgets/recipes_header.dart';

class NewRecipesScreen extends StatefulWidget {
  final TextEditingController searchController;
  final String? sortOrder;

  const NewRecipesScreen({
    super.key,
    required this.searchController,
    this.sortOrder,
  });

  @override
  State<NewRecipesScreen> createState() => _NewRecipesScreenState();
}

class _NewRecipesScreenState extends State<NewRecipesScreen> {
  List<Recipe>? _filteredRecipes;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(NewRecipesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sortOrder != oldWidget.sortOrder) {
      _applyFilterAndSort();
    }
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    final query = widget.searchController.text.toLowerCase();
    List<Recipe> tempRecipes = newRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(query);
    }).toList();

    if (widget.sortOrder != null) {
      tempRecipes.sort((a, b) {
        int weightA = _getDifficultyWeight(a.difficulty);
        int weightB = _getDifficultyWeight(b.difficulty);
        if (widget.sortOrder == 'easy') {
          return weightA.compareTo(weightB);
        } else {
          return weightB.compareTo(weightA);
        }
      });
    }

    setState(() {
      _filteredRecipes = tempRecipes;
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
    final displayRecipes = _filteredRecipes ?? newRecipes;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: displayRecipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(recipe: displayRecipes[index]);
        },
      ),
    );
  }
}
