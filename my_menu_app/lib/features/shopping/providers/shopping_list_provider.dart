import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shopping_item_model.dart';

class ShoppingListProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<ShoppingItem> _shoppingList = [];
  bool _isLoading = false;

  List<ShoppingItem> get shoppingList => _shoppingList;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners(); // Optional: notify to show loading state if desired

    try {
      final response = await _supabase
          .from('shopping_items')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _shoppingList = (response as List)
          .map((e) => ShoppingItem.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('Error fetching shopping list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String name) async {
    final user = _supabase.auth.currentUser;
    if (user == null || name.isEmpty) return;

    try {
      // Optimistic update
      // We can't easily do optimistic update without a temporary ID,
      // so we'll just wait for the server response or re-fetch.
      // For simplicity/robustness, let's insert and then re-fetch or append the returned row.

      final response = await _supabase
          .from('shopping_items')
          .insert({'user_id': user.id, 'name': name, 'is_checked': false})
          .select()
          .single();

      _shoppingList.insert(0, ShoppingItem.fromJson(response));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding item: $e');
    }
  }

  /// Adds multiple items (e.g. from a Recipe)
  Future<void> addItems(List<String> names) async {
    final user = _supabase.auth.currentUser;
    if (user == null || names.isEmpty) return;

    try {
      final List<Map<String, dynamic>> records = names
          .map(
            (name) => {'user_id': user.id, 'name': name, 'is_checked': false},
          )
          .toList();

      final response = await _supabase
          .from('shopping_items')
          .insert(records)
          .select();

      final newItems = (response as List)
          .map((e) => ShoppingItem.fromJson(e))
          .toList();

      _shoppingList.insertAll(0, newItems);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding multiple items: $e');
    }
  }

  Future<void> toggleItem(String id) async {
    final index = _shoppingList.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final oldItem = _shoppingList[index];
    final newItem = oldItem.copyWith(isChecked: !oldItem.isChecked);

    // Optimistic Update
    _shoppingList[index] = newItem;
    notifyListeners();

    try {
      await _supabase
          .from('shopping_items')
          .update({'is_checked': newItem.isChecked})
          .eq('id', id);
    } catch (e) {
      // Revert on failure
      _shoppingList[index] = oldItem;
      notifyListeners();
      debugPrint('Error toggling item: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    final index = _shoppingList.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final deletedItem = _shoppingList.removeAt(index);
    notifyListeners();

    try {
      await _supabase.from('shopping_items').delete().eq('id', id);
    } catch (e) {
      // Revert
      _shoppingList.insert(index, deletedItem);
      notifyListeners();
      debugPrint('Error deleting item: $e');
    }
  }
}
