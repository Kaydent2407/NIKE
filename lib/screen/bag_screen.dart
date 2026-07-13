import 'package:flutter/material.dart';

class BagScreen extends StatelessWidget {
  final bool isNike;
  final VoidCallback onShopNow; // Thêm hàm callback này

  const BagScreen({super.key, required this.isNike, required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    // Tự động đảo màu theo theme (Nike -> Trắng, Jordan -> Đen)
    final bgColor = isNike ? Colors.white : Colors.black;
    final fgColor = isNike ? Colors.black : Colors.white;
    final mutedTextColor = isNike ? Colors.grey.shade600 : Colors.grey.shade400;
    
    // Màu của nút bấm thì ngược lại với màu nền
    final btnBgColor = isNike ? Colors.black : Colors.white;
    final btnTextColor = isNike ? Colors.white : Colors.black;

    return Container(
      color: bgColor,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Phần nội dung chính nằm giữa màn hình
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Vòng tròn chứa Icon Giỏ hàng
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
                  
                  // Tiêu đề
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
                  
                  // Chữ mô tả nhỏ
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

            // 2. Nút "Shop Now" ở dưới đáy (Kê cao lên để không bị đè bởi thanh Navigation)
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
              child: GestureDetector(
                onTap: onShopNow, // Gắn hàm callback vào đây để kích hoạt chuyển tab
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: btnBgColor,
                    borderRadius: BorderRadius.circular(30), // Bo tròn thành viên thuốc
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
}