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

  // Thêm hàm cập nhật số lượng sản phẩm
  void updateQuantity(Shoe shoe, int newQuantity) {
    int index = _items.indexWhere((item) => item.shoe.id == shoe.id);
    if (index >= 0) {
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.removeAt(index); // Xóa khỏi giỏ nếu số lượng = 0
      }
      notifyListeners(); // Cập nhật lại UI và tính lại totalPrice
    }
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void removeFromCart(Shoe shoe) {
    _items.removeWhere((item) => item.shoe.id == shoe.id);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.shoe.price * item.quantity));
  }
  void clearCart() {
  _items.clear(); // Hoặc tên biến danh sách trong CartProvider của bạn
  notifyListeners();
}
}