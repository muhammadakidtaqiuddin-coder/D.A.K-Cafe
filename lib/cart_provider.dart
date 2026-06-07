import 'package:flutter/material.dart';

class CartItem {
  final int productId;
  final String name;
  final double price;
  final IconData icon;
  String size;
  String temperature;
  int sugarLevel;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.icon,
    this.size = 'Medium',
    this.temperature = 'Iced',
    this.sugarLevel = 50,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;

  String get priceLabel => 'RM ${price.toStringAsFixed(2)}';
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  double get serviceFee => _items.isEmpty ? 0.0 : 0.50;

  double get total => subtotal + serviceFee;

  void addItem(CartItem newItem) {
    final existing = _items.indexWhere(
      (i) =>
          i.productId == newItem.productId &&
          i.size == newItem.size &&
          i.temperature == newItem.temperature &&
          i.sugarLevel == newItem.sugarLevel,
    );
    if (existing >= 0) {
      _items[existing].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void increment(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decrement(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void remove(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
