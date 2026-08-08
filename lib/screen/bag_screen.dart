import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Import thư viện Slidable
import '../providers/cart_provider.dart';

class BagScreen extends StatelessWidget {
  final bool isNike;
  final VoidCallback onShopNow;

  const BagScreen({super.key, required this.isNike, required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    final bgColor = isNike ? Colors.white : Colors.black;
    final fgColor = isNike ? Colors.black : Colors.white;
    final mutedTextColor = isNike ? Colors.grey.shade600 : Colors.grey.shade400;
    final btnBgColor = isNike ? Colors.black : Colors.white;
    final btnTextColor = isNike ? Colors.white : Colors.black;

    return AnimatedBuilder(
      animation: CartProvider(),
      builder: (context, child) {
        final cartItems = CartProvider().items;

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
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
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
                // Header: Bag Title
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

                // Danh sách sản phẩm
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 120),
                    itemCount: cartItems.length + 1,
                    itemBuilder: (context, index) {
                      // Phần tử cuối cùng: Subtotal & Checkout
                      if (index == cartItems.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            margin: const EdgeInsets.only(top: 24),
                            padding: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade200, width: 0.5),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Subtotal", style: TextStyle(fontSize: 15, color: mutedTextColor)),
                                    Text(
                                      "đ${CartProvider().totalPrice.toStringAsFixed(0)}",
                                      style: TextStyle(fontSize: 15, color: mutedTextColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Shipping", style: TextStyle(fontSize: 15, color: mutedTextColor)),
                                    Text("Standard - Free", style: TextStyle(fontSize: 15, color: mutedTextColor)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: fgColor),
                                    ),
                                    Text(
                                      "đ${CartProvider().totalPrice.toStringAsFixed(0)}",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: fgColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: btnBgColor,
                                      foregroundColor: btnTextColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "Checkout",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final item = cartItems[index];

                      // SỬ DỤNG SLIDABLE THAY CHO DISMISSIBLE
                      return Slidable(
                        key: ValueKey(item.shoe.title + index.toString()),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.35, // Tỷ lệ chiều rộng hiện ra khi kéo (35% màn hình)
                          children: [
                            CustomSlidableAction(
                              onPressed: (context) {
                                // Xử lý Yêu thích
                              },
                              backgroundColor: const Color(0xFFF5F5F5),
                              foregroundColor: Colors.black,
                              child: const Icon(Icons.favorite_border, size: 22),
                            ),
                            CustomSlidableAction(
                              onPressed: (context) {
                                CartProvider().removeFromCart(item.shoe);
                              },
                              backgroundColor: const Color(0xFFF5F5F5),
                              foregroundColor: Colors.black,
                              child: const Icon(Icons.delete_outline, size: 22),
                            ),
                          ],
                        ),
                        child: Container(
                          color: bgColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ảnh sản phẩm
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: isNike ? Colors.grey.shade100 : Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.shoe.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Thông tin chi tiết
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                                    // Số lượng & Giá
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
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
                                            Icon(Icons.keyboard_arrow_down, size: 18, color: fgColor),
                                          ],
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