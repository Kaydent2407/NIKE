import 'package:flutter/material.dart';
import '../models/shoe_model.dart';

class CartItem {
  final Shoe shoe;
  int quantity;

  CartItem({required this.shoe, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  static final CartProvider instance = CartProvider._internal();
  factory CartProvider() => instance;
  CartProvider._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Shoe shoe) {
    int index = _items.indexWhere((item) => item.shoe.id == shoe.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(shoe: shoe));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }


  void removeFromCart(Shoe shoe) {
    // Tìm và xóa sản phẩm tương ứng ra khỏi danh sách items
    _items.removeWhere((item) => item.shoe.id == shoe.id); // Hoặc so sánh theo thuộc tính định danh duy nhất của sản phẩm
    
    notifyListeners(); // Cập nhật lại UI sau khi xóa
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.shoe.price * item.quantity));
  }
}