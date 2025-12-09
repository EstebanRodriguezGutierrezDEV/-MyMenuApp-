import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/fridge_service.dart';

class MyFridgeScreen extends StatelessWidget {
  const MyFridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Text(
            'Mi Nevera',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            tabs: const [
              Tab(text: 'Nevera'),
              Tab(text: 'Despensa'),
              Tab(text: 'Arcón'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FridgeSection(location: 'Nevera'),
            _FridgeSection(location: 'Despensa'),
            _FridgeSection(location: 'Arcón'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const _AddFoodModal(),
            );
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Añadir alimento',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _FridgeSection extends StatelessWidget {
  final String location;
  const _FridgeSection({required this.location});

  @override
  Widget build(BuildContext context) {
    final fridgeService = FridgeService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fridgeService.getItems(location),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!;
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay alimentos en $location',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final expiry = item['expiry_date'];

            return Dismissible(
              key: Key(item['id']),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                fridgeService.deleteItem(item['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['name']} eliminado')),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    item['name'],
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Cantidad: ${item['quantity'] ?? '-'}',
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                  trailing: expiry != null
                      ? Chip(
                          label: Text(
                            expiry,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.orange.withOpacity(0.1),
                          labelStyle: TextStyle(color: Colors.orange[800]),
                        )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AddFoodModal extends StatefulWidget {
  const _AddFoodModal();

  @override
  State<_AddFoodModal> createState() => _AddFoodModalState();
}

class _AddFoodModalState extends State<_AddFoodModal> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime? _expiryDate;
  String _selectedLocation = 'Nevera';
  bool _isLoading = false;

  final List<String> _locations = ['Nevera', 'Despensa', 'Arcón'];
  final _fridgeService = FridgeService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _saveItem() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await _fridgeService.addItem(
        name: _nameController.text.trim(),
        quantity: _quantityController.text.trim(),
        location: _selectedLocation,
        expiryDate: _expiryDate,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_nameController.text} añadido a $_selectedLocation',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Añadir Alimento',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre del alimento',
              prefixIcon: const Icon(Icons.restaurant_menu),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Cantidad (ej. 2, 500g)',
              prefixIcon: const Icon(Icons.scale),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    _expiryDate == null
                        ? 'Fecha de Caducidad'
                        : '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                    style: TextStyle(
                      color: _expiryDate == null
                          ? Colors.grey[700]
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            decoration: InputDecoration(
              labelText: 'Ubicación',
              prefixIcon: const Icon(Icons.place),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _locations.map((String loc) {
              return DropdownMenuItem<String>(value: loc, child: Text(loc));
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _selectedLocation = newValue);
              }
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveItem,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Guardar',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
