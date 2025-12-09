import 'package:flutter/material.dart';

class ShoppingListProvider extends ChangeNotifier {
  final List<String> _shoppingList = [];

  List<String> get shoppingList => _shoppingList;

  void addItem(String item) {
    if (item.isNotEmpty) {
      _shoppingList.add(item);
      notifyListeners();
    }
  }

  void addItems(List<String> items) {
    if (items.isNotEmpty) {
      _shoppingList.addAll(items);
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _shoppingList.length) {
      _shoppingList.removeAt(index);
      notifyListeners();
    }
  }
}
