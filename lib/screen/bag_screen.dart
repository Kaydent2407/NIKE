import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/cart_provider.dart';
import 'detail_screen.dart';
import 'checkout_screen.dart';

class BagScreen extends StatelessWidget {
  final bool isNike;
  final VoidCallback onShopNow;

  const BagScreen({super.key, required this.isNike, required this.onShopNow});

  // Dialog xác nhận Checkout
  void _showCheckoutConfirmationDialog(
      BuildContext context, Color bgColor, Color fgColor, CartProvider cart) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Xác nhận đơn hàng",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
            content: Text(
              "Bạn có chắc chắn muốn tiến hành thanh toán không?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isNike ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(
                  "Hủy",
                  style: TextStyle(
                    color: isNike ? Colors.grey.shade600 : Colors.grey.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 1. Lưu lại danh sách và tổng tiền để chuyển sang CheckoutScreen
                  final checkoutItems = cart.items.map((item) {
                    return {
                      'shoe': item.shoe,
                      'quantity': item.quantity,
                      'title': item.shoe.title,
                      'price': item.shoe.price,
                      'imageUrl': item.shoe.imageUrl,
                    };
                  }).toList();
                  final totalAmount = cart.totalPrice;

                  // 2. Xóa các sản phẩm trong giỏ hàng
                  cart.clearCart(); // Nếu hàm trong CartProvider tên là clear() thì sửa lại thành cart.clear()

                  // 3. Đóng Dialog
                  Navigator.of(dialogContext).pop();

                  // 4. Chuyển sang màn hình Checkout
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        cartItems: checkoutItems,
                        totalPrice: totalAmount,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNike ? Colors.black : Colors.white,
                  foregroundColor: isNike ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  "Checkout",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuantityPicker(
      BuildContext context, dynamic item, Color bgColor, Color fgColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Quantity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: fgColor,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final qty = index + 1;
                    return ListTile(
                      title: Text(
                        "$qty",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: item.quantity == qty
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: fgColor,
                        ),
                      ),
                      onTap: () {
                        CartProvider().updateQuantity(item.shoe, qty);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isNike ? Colors.white : Colors.black;
    final fgColor = isNike ? Colors.black : Colors.white;
    final mutedTextColor =
        isNike ? Colors.grey.shade600 : Colors.grey.shade400;
    final btnBgColor = isNike ? Colors.black : Colors.white;
    final btnTextColor = isNike ? Colors.white : Colors.black;

    return AnimatedBuilder(
      animation: CartProvider(),
      builder: (context, child) {
        final cart = CartProvider();
        final cartItems = cart.items;

        if (cartItems.isEmpty) {
          return Container(
            color: bgColor,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: fgColor, width: 1.2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 30,
                              color: fgColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Your Bag is empty.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: fgColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "When you add products, they'll\nappear here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: mutedTextColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, bottom: 120),
                    child: GestureDetector(
                      onTap: onShopNow,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: btnBgColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Shop Now",
                            style: TextStyle(
                              color: btnTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          color: bgColor,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                  child: Text(
                    "Bag",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: fgColor,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 120),
                    itemCount: cartItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index == cartItems.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            margin: const EdgeInsets.only(top: 24),
                            padding: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: Colors.grey.shade200, width: 0.5),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Subtotal",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: mutedTextColor)),
                                    Text(
                                      "đ${cart.totalPrice.toStringAsFixed(0)}",
                                      style: TextStyle(
                                          fontSize: 15, color: mutedTextColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Shipping",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: mutedTextColor)),
                                    Text("Standard - Free",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: mutedTextColor)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: fgColor),
                                    ),
                                    Text(
                                      "đ${cart.totalPrice.toStringAsFixed(0)}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: fgColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showCheckoutConfirmationDialog(
                                          context, bgColor, fgColor, cart);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: btnBgColor,
                                      foregroundColor: btnTextColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "Checkout",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final item = cartItems[index];

                      return Slidable(
                        key: ValueKey(item.shoe.title + index.toString()),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.35,
                          children: [
                            CustomSlidableAction(
                              onPressed: (context) {},
                              backgroundColor: const Color(0xFFF5F5F5),
                              foregroundColor: Colors.black,
                              child:
                                  const Icon(Icons.favorite_border, size: 22),
                            ),
                            CustomSlidableAction(
                              onPressed: (context) {
                                cart.removeFromCart(item.shoe);
                              },
                              backgroundColor: const Color(0xFFF5F5F5),
                              foregroundColor: Colors.black,
                              child:
                                  const Icon(Icons.delete_outline, size: 22),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(shoe: item.shoe),
                              ),
                            );
                          },
                          child: Container(
                            color: bgColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: isNike
                                        ? Colors.grey.shade100
                                        : Colors.grey.shade900,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.shoe.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.broken_image,
                                                  color: mutedTextColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.shoe.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: fgColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.shoe.brand,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mutedTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "EU 38.5",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mutedTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              _showQuantityPicker(context, item,
                                                  bgColor, fgColor);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Qty ${item.quantity}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: fgColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 2),
                                                Icon(Icons.keyboard_arrow_down,
                                                    size: 18, color: fgColor),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "đ${(item.shoe.price * item.quantity).toStringAsFixed(0)}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: fgColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}