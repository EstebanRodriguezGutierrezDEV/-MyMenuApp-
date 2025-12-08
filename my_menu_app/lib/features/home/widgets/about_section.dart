import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class AboutSection extends StatelessWidget {
  final Animation<double> animation;

  const AboutSection({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    Widget introText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Acerca de Nosotros',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          'Tu aliado para una vida saludable. Planifica menús, descubre recetas y genera listas automáticas en segundos.',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.white.withOpacity(0.95),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Comer bien nunca fue tan fácil. Ahorra tiempo, dinero y cuida de ti.',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.white.withOpacity(0.95),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    Widget statsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('📖', '1000+', 'Recetas'),
        _buildStatCard('👥', '500+', 'Usuarios'),
        _buildStatCard('⭐', '4.8', 'Valoración'),
      ],
    );

    Widget imageContent = AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/about_image.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 400,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Cocina saludable',
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF2C5530)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              introText,
              const SizedBox(height: 60),
              imageContent,
              const SizedBox(height: 60),
              statsRow,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String icon, String number, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(
          number,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
