import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 24),
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 1200),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(20, 30, 20, 0.85),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.only(right: 1),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, AppColors.primary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                'M',
                                style: GoogleFonts.stardosStencil(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: 'yMenu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Responsive Navigation Items
                  if (MediaQuery.of(context).size.width > 800)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNavItem('Menú'),
                        _buildNavItem('Sobre Nosotros'),
                        _buildNavItem('¿Cómo funciona?'),
                        _buildNavItem('Contactanos'),
                      ],
                    )
                  else
                    Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                          color: const Color.fromRGBO(20, 30, 20, 0.95),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onSelected: (value) {
                          debugPrint('Selected: $value');
                        },
                        itemBuilder: (BuildContext context) => [
                          _buildPopupMenuItem('Menú'),
                          _buildPopupMenuItem('Sobre Nosotros'),
                          _buildPopupMenuItem('¿Cómo funciona?'),
                          _buildPopupMenuItem('Contactanos'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      child: Text(text),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String text) {
    return PopupMenuItem<String>(
      value: text,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
