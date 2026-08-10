import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/currency_formatter.dart';
import 'order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController(text: "Nguyễn Văn A");
  final _phoneController = TextEditingController(text: "0901234567");
  final _addressController = TextEditingController(text: "123 Đường Lê Lợi, Q.1, TP.HCM");
  String _paymentMethod = "COD (Thanh toán khi nhận hàng)";
  bool _isProcessing = false;

  // Hàm lưu đơn hàng vào SharedPreferences
  Future<void> _saveOrderToLocalStorage() async {
    setState(() => _isProcessing = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Tạo đối tượng đơn hàng mới
      final newOrder = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'customerName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'paymentMethod': _paymentMethod,
        'totalPrice': widget.totalPrice,
        'status': 'Pending',
        'createdAt': DateTime.now().toIso8601String(),
        'items': widget.cartItems,
      };

      // 2. Lấy danh sách đơn hàng cũ từ SharedPreferences (nếu có)
      final String? existingOrdersJson = prefs.getString('local_orders');
      List<dynamic> existingOrders = [];

      if (existingOrdersJson != null && existingOrdersJson.isNotEmpty) {
        existingOrders = jsonDecode(existingOrdersJson);
      }

      // 3. Thêm đơn hàng mới vào đầu danh sách
      existingOrders.insert(0, newOrder);

      // 4. Lưu ngược lại chuỗi JSON vào SharedPreferences
      await prefs.setString('local_orders', jsonEncode(existingOrders));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đặt hàng thành công!")),
      );

      // 5. Chuyển sang màn hình Lịch sử đơn hàng
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi đặt hàng: $e")),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thanh toán",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thông tin giao hàng",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Họ và tên",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Số điện thoại",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "Địa chỉ nhận hàng",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Phương thức thanh toán",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text("COD (Thanh toán khi nhận hàng)"),
              value: "COD (Thanh toán khi nhận hàng)",
              groupValue: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
            RadioListTile<String>(
              title: const Text("Chuyển khoản ngân hàng"),
              value: "Chuyển khoản ngân hàng",
              groupValue: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng tiền thanh toán:", style: TextStyle(fontSize: 16)),
                Text(
                  CurrencyFormatter.format(widget.totalPrice),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _isProcessing ? null : _saveOrderToLocalStorage,
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "ĐẶT HÀNG",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}