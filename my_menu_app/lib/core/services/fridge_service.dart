import 'package:supabase_flutter/supabase_flutter.dart';

class FridgeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get items by location (Nevera, Despensa, Arcón)
  Stream<List<Map<String, dynamic>>> getItems(String location) {
    return _supabase
        .from('fridge_items')
        .stream(primaryKey: ['id'])
        .eq('location', location)
        .order('created_at', ascending: false);
  }

  // Add new item
  Future<void> addItem({
    required String name,
    required String quantity,
    required String location,
    DateTime? expiryDate,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('fridge_items').insert({
      'user_id': user.id,
      'name': name,
      'quantity': quantity,
      'location': location,
      'expiry_date': expiryDate?.toIso8601String().split('T')[0], // YYYY-MM-DD
    });
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    await _supabase.from('fridge_items').delete().eq('id', id);
  }
}
