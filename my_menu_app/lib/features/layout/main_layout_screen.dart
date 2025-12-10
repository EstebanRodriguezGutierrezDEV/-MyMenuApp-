import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../recipes/recipes_screen.dart';
import '../shopping/shopping_screen.dart';
import '../user/user_screen.dart';
import '../recipes/upload_recipe_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RecipesScreen(),
    const SizedBox(), // Dummy widget for the Add button
    const ShoppingScreen(),
    const UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadRecipeScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            // Index 1 is the space for FAB, so we don't switch to it
            // Adjust index logic for removed item
            if (index == 2) {
              // Compra
              setState(() => _currentIndex = 2);
            } else if (index == 3) {
              // Mi Cuenta
              setState(() => _currentIndex = 3);
            } else if (index == 0) {
              // Recetas
              setState(() => _currentIndex = 0);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A313A),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Recetas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add, color: Colors.transparent),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Compra',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Mi Cuenta',
            ),
          ],
        ),
      ),
    );
  }
}
