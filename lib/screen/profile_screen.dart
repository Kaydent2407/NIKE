import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import 'order_history_screen.dart'; // Import màn hình Lịch sử đơn hàng

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: currentUser != null
            ? FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
                .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic>? data;
          if (snapshot.hasData && snapshot.data!.exists) {
            data = snapshot.data!.data() as Map<String, dynamic>?;
          }

          // Lấy thông tin name và photoUrl từ Firestore hoặc FirebaseAuth
          String displayName = data?["name"] ??
              currentUser?.displayName ??
              "Nike Member";
          String? photoUrl = data?["photoUrl"] ?? data?["avatar"] ?? currentUser?.photoURL;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Avatar Icon Camera hoặc Ảnh người dùng
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? const Icon(
                          Icons.camera_alt_outlined,
                          size: 36,
                          color: Colors.white,
                        )
                      : null,
                ),

                const SizedBox(height: 16),

                // Tên người dùng
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // Nút Edit Profile
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Hàng Menu (Orders, Pass, Favorites, Settings)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Điều hướng sang OrderHistoryScreen khi bấm Orders
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrderHistoryScreen(),
                              ),
                            );
                          },
                          child: _buildMenuItem(Icons.card_giftcard_outlined, "Orders"),
                        ),
                        _buildDivider(),
                        _buildMenuItem(Icons.qr_code_scanner_outlined, "Pass"),
                        _buildDivider(),

                        // Điều hướng sang FavoritesScreen khi bấm Favorites
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                            );
                          },
                          child: _buildMenuItem(Icons.favorite_border, "Favorites"),
                        ),
                        _buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsScreen()),
                            );
                          },
                          child: _buildMenuItem(Icons.settings_outlined, "Settings"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Các mục thông tin danh sách
                _buildListItem("Inbox", "View messages"),
                _buildListItem("Your Nike Member Benefits", "2 available"),
                _buildListItem("Events", "View All Events"),

                const SizedBox(height: 24),

                // Section: Following (1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Following (1)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Hình ảnh trong mục Following
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300",
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Dòng chữ Member Since ở cuối
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: Colors.grey.shade100,
                  child: Text(
                    "Member Since May 2026",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget hiển thị cột icon + nhãn menu
  Widget _buildMenuItem(IconData icon, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 26, color: Colors.black),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Đường phân cách dọc giữa các nút menu
  Widget _buildDivider() {
    return VerticalDivider(
      color: Colors.grey.shade300,
      thickness: 1,
      width: 1,
      indent: 4,
      endIndent: 4,
    );
  }

  // Widget hiển thị từng hàng item danh sách (Inbox, Benefits, Events)
  Widget _buildListItem(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}