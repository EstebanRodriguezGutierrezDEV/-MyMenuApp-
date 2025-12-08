import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> _steps = [
    {
      'number': '1',
      'icon': '👤',
      'title': 'Personaliza tu Perfil',
      'description':
          'Regístrate y cuéntanos tus preferencias, alergias y objetivos. MyMenu se adapta a ti desde el primer día.',
    },
    {
      'number': '2',
      'icon': '📅',
      'title': 'Descubre y Planifica',
      'description':
          'Explora miles de recetas o deja que te sugiramos un menú semanal equilibrado. Organiza tus comidas con un solo clic.',
    },
    {
      'number': '3',
      'icon': '🛒',
      'title': 'Cocina y Disfruta',
      'description':
          'Genera tu lista de la compra automática y sigue nuestras recetas paso a paso. Comer saludable nunca fue tan fácil.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      color: AppColors.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildHeader(),
          ),
          const SizedBox(height: 10),
          _buildCarousel(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '¿Cómo funciona ',
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              TextSpan(
                text: 'MyMenu',
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: '?',
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Tu asistente personal para una alimentación inteligente',
          style: GoogleFonts.inter(
            fontSize: 18,
            color: AppColors.text.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _steps.length,
            itemBuilder: (context, index) {
              final step = _steps[index];
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildStepCard(
                    step['number']!,
                    step['icon']!,
                    step['title']!,
                    step['description']!,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_steps.length, (index) {
            bool isActive = _currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 32 : 12,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isActive
                    ? AppColors.primary
                    : Colors.grey.withOpacity(0.4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepCard(
    String number,
    String icon,
    String title,
    String description,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Text(icon, style: const TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.text.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
