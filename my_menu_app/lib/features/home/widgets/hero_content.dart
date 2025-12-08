import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'service_info.dart';
import 'about_section.dart';
import 'how_it_works_section.dart';
import 'cta_section.dart';
import 'footer_section.dart';

class HeroContent extends StatelessWidget {
  final Animation<double> animation;

  const HeroContent({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isDesktop = constraints.maxWidth > 900;

                  // Component 1: Title
                  Widget titleSection = Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cocina Saludable,\n',
                          style: GoogleFonts.outfit(
                            fontSize: isDesktop ? 64 : 42,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            color: AppColors.text,
                          ),
                        ),
                        TextSpan(
                          text: 'Vida Feliz',
                          style: GoogleFonts.outfit(
                            fontSize: isDesktop ? 64 : 42,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                  );

                  // Component 2: Description
                  Widget descriptionSection = Text(
                    'Descubre miles de recetas, planifica tus comidas y lleva una vida más saludable con MyMenu.',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: AppColors.text.withOpacity(0.8),
                      height: 1.5,
                    ),
                    textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                  );

                  // Component 3: Buttons
                  Widget buttonsSection = Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Ver Menú'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Únete Ahora'),
                      ),
                    ],
                  );

                  // Component 4: Image (Floating)
                  Widget imageContent = AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, animation.value),
                        child: child,
                      );
                    },
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/hero_food.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 300,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  );

                  if (isDesktop) {
                    // Desktop: Text Column (left) | Image (right)
                    return Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titleSection,
                                  const SizedBox(height: 24),
                                  descriptionSection,
                                  const SizedBox(height: 40),
                                  buttonsSection,
                                  const SizedBox(height: 80),
                                  ServiceInfo(animation: animation),
                                ],
                              ),
                            ),
                            const SizedBox(width: 48),
                            Expanded(child: imageContent),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Mobile: Title -> Image -> Description -> Buttons
                    return Column(
                      children: [
                        titleSection,
                        const SizedBox(height: 40),
                        imageContent,
                        const SizedBox(height: 40),
                        descriptionSection,
                        const SizedBox(height: 32),
                        buttonsSection,
                        ServiceInfo(animation: animation),
                      ],
                    );
                  }
                },
              ),
            ),
            AboutSection(animation: animation),
            const HowItWorksSection(),
            const CallToActionSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
