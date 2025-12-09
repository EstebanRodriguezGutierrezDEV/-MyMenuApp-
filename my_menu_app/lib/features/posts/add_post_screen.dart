import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      appBar: AppBar(
        title: Text(
          'Nueva Publicación',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.post_add,
              size: 64,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Crea tu publicación aquí',
              style: GoogleFonts.inter(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
