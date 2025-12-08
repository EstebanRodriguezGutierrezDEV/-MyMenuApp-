import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;
  final Color textColor;
  final Color iconColor;

  const AppLogo({
    super.key,
    this.fontSize = 32,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.only(right: 2),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'M',
                  style: GoogleFonts.stardosStencil(
                    fontSize: fontSize * 1.25, // Slightly larger than text
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
          TextSpan(
            text: 'yMenu',
            style: GoogleFonts.outfit(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
