import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

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
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: currentUser != null
            ? FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
                .snapshots()
            : null,
        builder: (context, snapshot) {
          Map<String, dynamic>? data;
          if (snapshot.hasData && snapshot.data!.exists) {
            data = snapshot.data!.data() as Map<String, dynamic>?;
          }

          String email = currentUser?.email ?? data?["email"] ?? "hlancuti2910@gmail.com";
          String phone = data?["phone"] ?? "Add";
          String dob = data?["dob"] ?? "29/10/2006";

          return ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              // Group 1: Account Info
              _buildValueTile("Email", email),
              _buildValueTile("Mobile Number", phone),
              _buildValueTile("Date of Birth", dob),
              _buildNavigationTile("Units of Measure"),

              _buildSectionSpacer(),

              // Group 2: Shipping & Payment
              _buildNavigationTile("Shipping Information"),
              _buildNavigationTile("Payment Information"),

              _buildSectionSpacer(),

              // Group 3: Region & Preferences
              _buildNavigationTile("Country/Region"),
              _buildNavigationTile("Language"),
              _buildNavigationTile("Shopping Settings"),

              _buildSectionSpacer(),

              // Group 4: Notifications
              _buildNavigationTile("Location Settings"),
              _buildNavigationTile("Notifications"),

              _buildSectionSpacer(),

              // Group 5: Profile & Workout
              _buildNavigationTile("Privacy"),
              _buildNavigationTile("Profile Visibility"),
              _buildNavigationTile("Workout Info"),

              _buildSectionSpacer(),

              // Group 6: Support & Apps
              _buildNavigationTile("Find a Nike Store"),
              _buildNavigationTile("Get Help"),
              _buildNavigationTile("Explore Our Apps"),

              _buildSectionSpacer(),

              // Group 7: Legal & Policies
              _buildNavigationTile("About This Version"),
              _buildNavigationTile("Terms of Use"),
              _buildNavigationTile("Terms of Sale"),
              _buildNavigationTile("Privacy Policy"),
              _buildNavigationTile("Returns Policy"),

              _buildSectionSpacer(),

              // Group 8: Account Actions
              _buildNavigationTile("Delete Account"),

              _buildSectionSpacer(),

              // Log Out Button
              _buildActionTile(
                "Log Out",
                onTap: () => _handleLogout(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionSpacer() {
    return Container(
      height: 14,
      color: const Color(0xFFF6F6F6),
    );
  }

  Widget _buildValueTile(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.8)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: value == "Add" ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationTile(String title, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.8)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ),
    );
  }

  Widget _buildActionTile(String title, {required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.8)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
    );
  }
}