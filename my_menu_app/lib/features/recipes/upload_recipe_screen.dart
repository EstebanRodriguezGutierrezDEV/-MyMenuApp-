import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/services/recipe_service.dart';
import '../recipes/models/recipe_model.dart';

class UploadRecipeScreen extends StatefulWidget {
  const UploadRecipeScreen({super.key});

  @override
  State<UploadRecipeScreen> createState() => _UploadRecipeScreenState();
}

class _UploadRecipeScreenState extends State<UploadRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipeService = RecipeService();
  bool _isLoading = false;

  // Image Selection
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Form Fields
  final _titleController = TextEditingController();
  final _timeController = TextEditingController(); // Optional now
  final _caloriesController = TextEditingController(); // Optional now
  final _descriptionController = TextEditingController();

  String _difficulty = 'Fácil';
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _caloriesController.dispose();
    _descriptionController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Pick image from source
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index].dispose();
        _ingredientControllers.removeAt(index);
      });
    }
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String imageUrl =
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=60';

      // 1. Upload Image if selected
      if (_selectedImage != null) {
        final uploadedUrl = await _recipeService.uploadImage(_selectedImage!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      final ingredients = _ingredientControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final newRecipe = Recipe(
        title: _titleController.text.trim(),
        imageUrl: imageUrl,
        difficulty: _difficulty,
        time: _timeController.text.trim().isEmpty
            ? 'N/A'
            : _timeController.text.trim(),
        description: _descriptionController.text.trim(),
        calories: _caloriesController.text.trim().isEmpty
            ? 'N/A'
            : _caloriesController.text.trim(),
        ingredients: ingredients,
      );

      await _recipeService.createRecipe(newRecipe);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Receta publicada con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Return to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al publicar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      appBar: AppBar(
        title: Text(
          'Nueva Receta',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Foto del Plato'),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _selectedImage == null
                          ? Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Cámara'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Galería'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Información Básica'),
                    _buildTextField(
                      controller: _titleController,
                      label: 'Título de la receta',
                      icon: Icons.title,
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _timeController,
                            label: 'Tiempo (Opcional)',
                            icon: Icons.timer,
                            required: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _caloriesController,
                            label: 'Calorías (Opcional)',
                            icon: Icons.local_fire_department,
                            required: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _difficulty,
                      decoration: _inputDecoration(
                        'Dificultad',
                        Icons.bar_chart,
                      ),
                      items: ['Fácil', 'Medio', 'Difícil']
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label, style: GoogleFonts.inter()),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _difficulty = val!),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Descripción'),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Describe tu plato...',
                      icon: Icons.description,
                      maxLines: 3,
                      required: false,
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Ingredientes'),
                    ..._ingredientControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller,
                                label: 'Ingrediente ${index + 1}',
                                icon: Icons.restaurant_menu,
                                required: true,
                              ),
                            ),
                            if (_ingredientControllers.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeIngredientField(index),
                              ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: _addIngredientField,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Añadir ingrediente'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _submitRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Publicar Receta',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A313A),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    required bool required,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Campo requerido';
        }
        return null;
      },
      decoration: _inputDecoration(label, icon),
      style: GoogleFonts.inter(),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
