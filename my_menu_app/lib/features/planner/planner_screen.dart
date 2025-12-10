import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/meal_plan_service.dart';
import 'models/meal_plan_model.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final _mealPlanService = MealPlanService();
  DateTime _startOfWeek = DateTime.now().subtract(
    Duration(days: DateTime.now().weekday - 1),
  ); // Monday
  List<MealPlan> _weeklyPlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    setState(() => _isLoading = true);
    try {
      final endOfWeek = _startOfWeek.add(const Duration(days: 6));
      final plans = await _mealPlanService.getWeeklyPlan(
        _startOfWeek,
        endOfWeek,
      );
      setState(() {
        _weeklyPlans = plans;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching plans: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateSmartPlan() async {
    setState(() => _isLoading = true);
    try {
      final suggestions = await _mealPlanService.generateSmartPlan(
        _startOfWeek,
      );

      if (!mounted) return;

      // Show preview dialog
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) => _SmartPlanPreviewDialog(suggestions: suggestions),
      );

      if (shouldSave == true) {
        // Save all suggestions
        for (var plan in suggestions) {
          await _mealPlanService.savePlan(plan);
        }
        await _fetchPlans();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Menú inteligente guardado!')),
          );
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error generating smart plan: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      appBar: AppBar(
        title: Text(
          'Planificador Semanal',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: _generateSmartPlan,
            tooltip: 'Generar Menú Inteligente',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Week Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(7, (index) {
                      final date = _startOfWeek.add(Duration(days: index));
                      final isToday =
                          date.day == DateTime.now().day &&
                          date.month == DateTime.now().month;
                      final dayName = [
                        'LUN',
                        'MAR',
                        'MIE',
                        'JUE',
                        'VIE',
                        'SAB',
                        'DOM',
                      ][index];

                      return Column(
                        children: [
                          Text(
                            dayName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: isToday ? AppColors.primary : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${date.day}',
                              style: GoogleFonts.outfit(
                                color: isToday ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                // Content
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final date = _startOfWeek.add(Duration(days: index));
                      final dayPlans = _weeklyPlans
                          .where(
                            (p) =>
                                p.date.day == date.day &&
                                p.date.month == date.month,
                          )
                          .toList();

                      final lunch = dayPlans
                          .where((p) => p.mealType == 'lunch')
                          .firstOrNull;
                      final dinner = dayPlans
                          .where((p) => p.mealType == 'dinner')
                          .firstOrNull;

                      final dayName = [
                        'Lunes',
                        'Martes',
                        'Miércoles',
                        'Jueves',
                        'Viernes',
                        'Sábado',
                        'Domingo',
                      ][index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dayName,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A313A),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildMealSlot(
                                context,
                                'Comida',
                                lunch,
                                date,
                                'lunch',
                              ),
                              const Divider(height: 24),
                              _buildMealSlot(
                                context,
                                'Cena',
                                dinner,
                                date,
                                'dinner',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMealSlot(
    BuildContext context,
    String label,
    MealPlan? plan,
    DateTime date,
    String type,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: type == 'lunch'
                ? Colors.orange.withOpacity(0.1)
                : Colors.indigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            type == 'lunch'
                ? Icons.wb_sunny_outlined
                : Icons.nights_stay_outlined,
            color: type == 'lunch' ? Colors.orange : Colors.indigo,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
              ),
              if (plan != null && plan.recipe != null)
                Text(
                  plan.recipe!['title'],
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              else
                Text(
                  'Añadir receta...',
                  style: GoogleFonts.inter(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),
        ),
        if (plan != null)
          Icon(Icons.check_circle, color: Colors.green[400], size: 20)
        else
          Icon(Icons.add_circle_outline, color: Colors.grey[300], size: 20),
      ],
    );
  }
}

class _SmartPlanPreviewDialog extends StatelessWidget {
  final List<MealPlan> suggestions;

  const _SmartPlanPreviewDialog({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Menú Inteligente',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ],
      ), // Fixed: Removed extra parenthesis here
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hemos encontrado ${suggestions.length} recetas usando ingredientes de tu nevera:',
                style: GoogleFonts.inter(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              ...suggestions.map(
                (plan) {
                  final dayName = [
                    'LUN',
                    'MAR',
                    'MIE',
                    'JUE',
                    'VIE',
                    'SAB',
                    'DOM',
                  ][plan.date.weekday - 1];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        dayName,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    title: Text(
                      plan.recipe!['title'],
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      plan.mealType == 'lunch' ? 'Comida' : 'Cena',
                    ),
                  );
                },
              ), // Fixed: .toList() is not needed for spread operator inside a list context usually, but map returns Iterable.
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Aplicar Plan'),
        ),
      ],
    );
  }
}
