import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/shopping_list_provider.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final TextEditingController _itemController = TextEditingController();

  void _addItem() {
    if (_itemController.text.isNotEmpty) {
      context.read<ShoppingListProvider>().addItem(_itemController.text);
      _itemController.clear();
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F5),
      body: Column(
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 20,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Lista de Compra',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Input Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // PDF Button
                ElevatedButton.icon(
                  onPressed: () {
                    // PDF functionality placeholder
                  },
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text('PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A313A),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Input Field
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintText: 'Añadir alimento...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                // Add Button
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Añadir',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // List or Empty State
          Expanded(
            child: Consumer<ShoppingListProvider>(
              builder: (context, provider, child) {
                if (provider.shoppingList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket_outlined,
                          size: 64,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tu lista de la compra está vacía.',
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.shoppingList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.grey,
                        ),
                        title: Text(
                          provider.shoppingList[index],
                          style: GoogleFonts.inter(fontSize: 16),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => provider.removeItem(index),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
