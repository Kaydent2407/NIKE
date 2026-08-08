import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _hometownController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _photoUrl;
  int _bioLength = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _bioController.addListener(() {
      setState(() {
        _bioLength = _bioController.text.length;
      });
    });
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Tách tên nếu chỉ lưu 1 trường "name"
        String fullName = data["name"] ?? currentUser.displayName ?? "";
        List<String> nameParts = fullName.trim().split(" ");

        if (data.containsKey("firstName") && data.containsKey("lastName")) {
          _firstNameController.text = data["firstName"] ?? "";
          _lastNameController.text = data["lastName"] ?? "";
        } else if (nameParts.length > 1) {
          _firstNameController.text = nameParts.sublist(0, nameParts.length - 1).join(" ");
          _lastNameController.text = nameParts.last;
        } else {
          _firstNameController.text = fullName;
          _lastNameController.text = "";
        }

        _hometownController.text = data["hometown"] ?? "";
        _bioController.text = data["bio"] ?? "";
        _photoUrl = data["photoUrl"] ?? data["avatar"] ?? currentUser.photoURL;
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      _isSaving = true;
    });

    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String fullName = "$firstName $lastName".trim();

    try {
      await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
        "firstName": firstName,
        "lastName": lastName,
        "name": fullName,
        "hometown": _hometownController.text.trim(),
        "bio": _bioController.text.trim(),
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _hometownController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Save Button
              GestureDetector(
                onTap: _isSaving ? null : _saveUserData,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Avatar & Edit Camera Button
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
                            ? NetworkImage(_photoUrl!)
                            : null,
                        child: _photoUrl == null || _photoUrl!.isEmpty
                            ? const Icon(
                                Icons.camera_alt_outlined,
                                size: 36,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () {
                      // Xử lý đổi ảnh avatar nếu muốn
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Section Name
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Custom Double Border Input Field for First/Last Name
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: InputBorder.none,
                            hintText: "First Name",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Divider(height: 1, thickness: 1, color: Colors.grey.shade400),
                        TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: InputBorder.none,
                            hintText: "Last Name",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section Hometown
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hometown",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _hometownController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      hintText: "City, State",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Colors.black, width: 1.2),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),

                  const SizedBox(height: 24),

                  // Section Bio Header & Character Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bio",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "$_bioLength/150",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Bio Multiline Input Field
                  TextField(
                    controller: _bioController,
                    maxLength: 150,
                    maxLines: 4,
                    decoration: InputDecoration(
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      hintText: "150 characters",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Colors.black, width: 1.2),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}