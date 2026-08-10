import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Thêm thư viện này để format ngày tháng (nhớ thêm intl vào pubspec.yaml)
import 'splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  // Hiển thị thông báo (SnackBar) đẹp mắt
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade600 : Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Bật/tắt trạng thái loading
  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  // 1. Đăng xuất
  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    }
  }

  // 2. Cập nhật field bất kỳ lên Firestore
  Future<void> _updateFirestoreField(String field, String value) async {
    if (currentUser == null) return;
    try {
      _setLoading(true);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .set({field: value}, SetOptions(merge: true)); // Dùng SetOptions để không ghi đè mất data cũ
      _showSnackBar("Updated successfully!");
    } catch (e) {
      _showSnackBar("Failed to update: ${e.toString()}", isError: true);
    } finally {
      _setLoading(false);
    }
  }

  // 3. Đổi Email (Firebase Auth có gửi mail xác thực)
  Future<void> _updateEmail() async {
    final TextEditingController emailController = TextEditingController();
    
    await _showEditBottomSheet(
      title: "Update Email",
      controller: emailController,
      hintText: "Enter new email address",
      keyboardType: TextInputType.emailAddress,
      onSave: () async {
        final newEmail = emailController.text.trim();
        if (newEmail.isEmpty || !newEmail.contains("@")) {
          _showSnackBar("Please enter a valid email", isError: true);
          return;
        }
        
        Navigator.pop(context); // Đóng bottom sheet
        _setLoading(true);
        try {
          // Firebase tự động gửi link xác nhận đến email mới
          await currentUser!.verifyBeforeUpdateEmail(newEmail);
          
          // Lưu tạm email mới lên Firestore (Hoặc bạn có thể chờ user click link xác nhận mới lưu)
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser!.uid)
              .set({"email": newEmail}, SetOptions(merge: true));
              
          _showSnackBar("Verification link sent to $newEmail. Please check your inbox.");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            _showSnackBar("Security alert: Please log out and log back in to change your email.", isError: true);
          } else {
            _showSnackBar(e.message ?? "Failed to update email", isError: true);
          }
        } finally {
          _setLoading(false);
        }
      },
    );
  }

  // 4. Đổi Số điện thoại (Chỉ lưu Firestore)
  Future<void> _updatePhone() async {
    final TextEditingController phoneController = TextEditingController();
    await _showEditBottomSheet(
      title: "Update Mobile Number",
      controller: phoneController,
      hintText: "Enter your phone number",
      keyboardType: TextInputType.phone,
      onSave: () async {
        final newPhone = phoneController.text.trim();
        if (newPhone.isNotEmpty) {
          Navigator.pop(context);
          await _updateFirestoreField("phone", newPhone);
        }
      },
    );
  }

  // 5. Chọn Ngày sinh (Mở Lịch hệ thống)
  Future<void> _updateDOB() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Màu header của lịch
              onPrimary: Colors.white, // Màu chữ trên header
              onSurface: Colors.black, // Màu chữ ngày tháng
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Ép kiểu format dd/MM/yyyy
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      await _updateFirestoreField("dob", formattedDate);
    }
  }

  // 6. Xóa tài khoản
  Future<void> _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("Are you sure you want to permanently delete your account? This action cannot be undone."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Tắt dialog
              _setLoading(true);
              try {
                // Xóa data trên Firestore trước (tuỳ chọn)
                await FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).delete();
                // Xóa User Firebase Auth
                await currentUser!.delete();
                
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SplashScreen()),
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'requires-recent-login') {
                  _showSnackBar("Please log out and log back in to delete your account.", isError: true);
                } else {
                  _showSnackBar(e.message ?? "Error deleting account", isError: true);
                }
              } finally {
                if (mounted) _setLoading(false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Nền tảng Popup trượt từ dưới lên để chỉnh sửa text
  Future<void> _showEditBottomSheet({
    required String title,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required VoidCallback onSave,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Đẩy popup lên khi bật bàn phím
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: hintText,
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Dành cho những tính năng chưa làm (để báo "Coming soon")
  void _showComingSoon() {
    _showSnackBar("This feature is coming soon!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: currentUser != null
                ? FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).snapshots()
                : null,
            builder: (context, snapshot) {
              Map<String, dynamic>? data;
              if (snapshot.hasData && snapshot.data!.exists) {
                data = snapshot.data!.data() as Map<String, dynamic>?;
              }

              // Ưu tiên email từ Auth, nếu không có thì lấy Firestore
              String email = currentUser?.email ?? data?["email"] ?? "Add Email";
              String phone = data?["phone"] ?? "Add";
              String dob = data?["dob"] ?? "Add";

              return ListView(
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  // Group 1: Account Info
                  _buildValueTile("Email", email, onTap: _updateEmail),
                  _buildValueTile("Mobile Number", phone, onTap: _updatePhone),
                  _buildValueTile("Date of Birth", dob, onTap: _updateDOB),
                  _buildNavigationTile("Units of Measure", onTap: _showComingSoon),

                  _buildSectionSpacer(),

                  // Group 2: Shipping & Payment
                  _buildNavigationTile("Shipping Information", onTap: _showComingSoon),
                  _buildNavigationTile("Payment Information", onTap: _showComingSoon),

                  _buildSectionSpacer(),

                  // Group 3: Region & Preferences
                  _buildNavigationTile("Country/Region", onTap: _showComingSoon),
                  _buildNavigationTile("Language", onTap: _showComingSoon),
                  _buildNavigationTile("Shopping Settings", onTap: _showComingSoon),

                  _buildSectionSpacer(),

                  // Group 4: Notifications
                  _buildNavigationTile("Location Settings", onTap: _showComingSoon),
                  _buildNavigationTile("Notifications", onTap: _showComingSoon),

                  _buildSectionSpacer(),

                  // Group 5: Profile & Workout
                  _buildNavigationTile("Privacy", onTap: _showComingSoon),
                  _buildNavigationTile("Profile Visibility", onTap: _showComingSoon),
                  _buildNavigationTile("Workout Info", onTap: _showComingSoon),

                  _buildSectionSpacer(),

                  // Group 6: Support & Apps
                  _buildNavigationTile("Find a Nike Store", onTap: _showComingSoon),
                  _buildNavigationTile("Get Help", onTap: _showComingSoon),
                  _buildNavigationTile("Explore Our Apps", onTap: _showComingSoon),

                  _buildSectionSpacer(),

                  // Group 7: Legal & Policies
                  _buildNavigationTile("About This Version", onTap: _showComingSoon),
                  _buildNavigationTile("Terms of Use", onTap: _showComingSoon),
                  _buildNavigationTile("Terms of Sale", onTap: _showComingSoon),
                  _buildNavigationTile("Privacy Policy", onTap: _showComingSoon),
                  _buildNavigationTile("Returns Policy", onTap: _showComingSoon),

                  _buildSectionSpacer(),

                  // Group 8: Account Actions
                  _buildActionTile("Delete Account", onTap: _deleteAccount, isDestructive: true),

                  _buildSectionSpacer(),

                  // Log Out Button
                  _buildActionTile("Log Out", onTap: _handleLogout),
                ],
              );
            },
          ),
          
          // Hiển thị vòng xoay loading mờ trên cùng màn hình khi đang lưu dữ liệu
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionSpacer() {
    return Container(
      height: 14,
      color: const Color(0xFFF6F6F6),
    );
  }

  // Tile có chứa Value (Cho Email, Phone, DOB) - Có hiệu ứng bấm (InkWell)
  Widget _buildValueTile(String title, String value, {required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.8)),
      ),
      child: InkWell(
        onTap: onTap,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: value == "Add" || value == "Add Email" ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit_outlined, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tile Điều hướng thông thường
  Widget _buildNavigationTile(String title, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.8)),
      ),
      child: InkWell(
        onTap: onTap,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Tile Action (Cho Log Out / Delete Account)
  Widget _buildActionTile(String title, {required VoidCallback onTap, bool isDestructive = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.8)),
      ),
      child: InkWell(
        onTap: onTap,
        highlightColor: isDestructive ? Colors.red.shade50 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15, 
              fontWeight: FontWeight.w500, 
              color: isDestructive ? Colors.red.shade600 : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}