import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/auth_service.dart';

class UserPreferencesScreen extends StatefulWidget {
  const UserPreferencesScreen({super.key});

  @override
  State<UserPreferencesScreen> createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isSaving = false;

  // Selected values
  final Set<String> _selectedAllergies = {};
  final Set<String> _selectedIntolerances = {};

  // Data Models
  final List<PreferenceOption> _allergyOptions = [
    PreferenceOption('Gluten', Icons.bakery_dining),
    PreferenceOption('Frutos secos', Icons.grass),
    PreferenceOption('Huevo', Icons.egg),
    PreferenceOption(
      'Leche',
      Icons.local_drink,
    ), // Or local_cafe or inversed colors
    PreferenceOption('Marisco', Icons.set_meal),
    PreferenceOption('Pescado', Icons.phishing),
    PreferenceOption('Soja', Icons.spa),
    PreferenceOption('Cacahuetes', Icons.scatter_plot),
    PreferenceOption('Sésamo', Icons.grain),
    PreferenceOption('Mostaza', Icons.local_pizza),
  ];

  final List<PreferenceOption> _intoleranceOptions = [
    PreferenceOption('Lactosa', Icons.icecream),
    PreferenceOption('Fructosa', Icons.apple),
    PreferenceOption('Histamina', Icons.warning_amber),
    PreferenceOption('Sorbitol', Icons.science),
    PreferenceOption('Gluten (Sensibilidad)', Icons.bakery_dining),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await _authService.getUserPreferences();
      if (prefs != null && mounted) {
        setState(() {
          if (prefs['allergies'] != null) {
            _selectedAllergies.clear();
            _selectedAllergies.addAll(List<String>.from(prefs['allergies']));
          }
          if (prefs['intolerances'] != null) {
            _selectedIntolerances.clear();
            _selectedIntolerances.addAll(
              List<String>.from(prefs['intolerances']),
            );
          }
        });
      }
    } catch (e) {
      print('DEBUG: Error loading preferences: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);
    try {
      await _authService.updateUserPreferences(
        allergies: _selectedAllergies.toList(),
        intolerances: _selectedIntolerances.toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Preferencias guardadas correctamente!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9F9F5),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      appBar: AppBar(
        title: Text(
          'Mis Preferencias',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save, color: Colors.white),
            onPressed: _isSaving ? null : _savePreferences,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Alergias',
              'Selecciona los alimentos que te causan alergia',
              Icons.warning_amber_rounded,
            ),
            const SizedBox(height: 16),
            _buildGrid(_allergyOptions, _selectedAllergies),

            const SizedBox(height: 32),

            _buildSectionHeader(
              'Intolerancias',
              'Selecciona los alimentos a los que tienes intolerancia',
              Icons.block_rounded,
            ),
            const SizedBox(height: 16),
            _buildGrid(_intoleranceOptions, _selectedIntolerances),

            const SizedBox(height: 80), // Bottom padding for FAB or button
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _savePreferences,
        backgroundColor: AppColors.primary,
        icon: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.check, color: Colors.white),
        label: Text(
          _isSaving ? 'Guardando...' : 'Guardar Cambios',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.text.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<PreferenceOption> options, Set<String> selectedSet) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 items per row
        childAspectRatio: 0.85, // Adjust height/width ratio
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedSet.contains(option.name);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedSet.remove(option.name);
              } else {
                selectedSet.add(option.name);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  option.icon,
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  option.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PreferenceOption {
  final String name;
  final IconData icon;

  PreferenceOption(this.name, this.icon);
}
