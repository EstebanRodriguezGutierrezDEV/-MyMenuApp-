import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class ServiceInfo extends StatelessWidget {
  final Animation<double> animation;

  const ServiceInfo({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    Widget imageSection = Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/service_image.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant_menu,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Planificación de comidas',
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transforma tu Cocina',
          style: GoogleFonts.outfit(
            fontSize: 32, // 2rem approx
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Olvídate del "¿qué comemos hoy?". Con '),
              TextSpan(
                text: 'MyMenu',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ', tienes el control total.'),
            ],
          ),
          style: GoogleFonts.inter(
            fontSize: 18,
            color: AppColors.text.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Center(child: imageSection),
        const SizedBox(height: 32),
        _buildFeatureItem(
          icon: '🥗',
          title: 'Vida Saludable',
          description:
              'Planes nutricionales equilibrados adaptados a tus objetivos.',
        ),
        const SizedBox(height: 24),
        _buildFeatureItem(
          icon: '⭐',
          title: 'Calidad Michelin',
          description:
              'Recetas exclusivas para sorprender en ocasiones especiales.',
        ),
        const SizedBox(height: 24),
        _buildFeatureItem(
          icon: '🛒',
          title: 'Lista Inteligente',
          description:
              'Genera tu lista de la compra automáticamente y ahorra tiempo.',
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(top: 80),
      constraints: const BoxConstraints(maxWidth: 800),
      child: content,
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(icon, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.text.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
