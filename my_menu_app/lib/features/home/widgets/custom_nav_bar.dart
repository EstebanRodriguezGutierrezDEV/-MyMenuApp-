import 'dart:ui';
import 'package:flutter/material.dart';
import '../../auth/login_screen.dart';
import '../../auth/signup_screen.dart';
import '../../../shared/widgets/app_logo.dart';

class CustomNavBar extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onHowItWorksTap;

  const CustomNavBar({
    super.key,
    this.onMenuTap,
    this.onAboutTap,
    this.onHowItWorksTap,
  });

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
                  const AppLogo(
                    fontSize: 24,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  // Responsive Navigation Items
                  if (MediaQuery.of(context).size.width > 800)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNavItem('Menú', onMenuTap),
                        _buildNavItem('Sobre Nosotros', onAboutTap),
                        _buildNavItem('¿Cómo funciona?', onHowItWorksTap),
                        _buildNavItem('Contactanos', () {}),
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
                          switch (value) {
                            case 'Menú':
                              onMenuTap?.call();
                              break;
                            case 'Sobre Nosotros':
                              onAboutTap?.call();
                              break;
                            case '¿Cómo funciona?':
                              onHowItWorksTap?.call();
                              break;
                            case 'Iniciar sesión':
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                              break;
                            case 'Registrarse':
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          _buildPopupMenuItem('Menú'),
                          _buildPopupMenuItem('Sobre Nosotros'),
                          _buildPopupMenuItem('¿Cómo funciona?'),
                          _buildPopupMenuItem('Contactanos'),
                          const PopupMenuDivider(height: 16),
                          _buildPopupMenuItem('Iniciar sesión'),
                          _buildPopupMenuItem('Registrarse'),
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

  Widget _buildNavItem(String text, VoidCallback? onTap) {
    return TextButton(
      onPressed: onTap,
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
