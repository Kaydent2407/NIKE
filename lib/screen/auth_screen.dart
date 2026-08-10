import 'package:flutter/gestures.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

import 'splash_screen.dart';
import '../widgets/app_logo.dart'; 
import 'privacy_policy_screen.dart';   
import 'terms_of_use_screen.dart';  

class AuthScreen extends StatefulWidget {
  final bool isInitialSignIn; 
  const AuthScreen({super.key, this.isInitialSignIn = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isSignIn;
  bool _rememberMe = false;
  bool _agreeTerms = false;
  bool _isEnglish = true;
  
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _isSignIn = widget.isInitialSignIn;
    _loadSavedEmail(); 
  }

  // Hàm tải Email đã lưu từ lần đăng nhập trước
  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail; 
        _rememberMe = true;                
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _t(String en, String vi) {
    return _isEnglish ? en : vi;
  }

  // ==========================================
  // HIỂN THỊ BOTTOM SHEET QUÊN MẬT KHẨU
  // ==========================================
  Future<void> _showForgotPasswordBottomSheet() async {
    final TextEditingController resetEmailController = TextEditingController();
    
    // Nếu người dùng đã gõ email ở ngoài, tự động điền vào khung quên mật khẩu
    if (_emailController.text.isNotEmpty) {
      resetEmailController.text = _emailController.text.trim();
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép bottom sheet đẩy lên khi bật bàn phím
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        bool isSending = false; // Trạng thái loading riêng của bottom sheet
        
        // Dùng StatefulBuilder để cập nhật UI bên trong BottomSheet mà không ảnh hưởng màn hình ngoài
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t('Reset Password', 'Khôi phục mật khẩu'),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _t(
                      'Enter your email address and we will send you a link to reset your password.',
                      'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi liên kết để đặt lại mật khẩu.'
                    ),
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  
                  // Ô nhập Email
                  TextField(
                    controller: resetEmailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: _t('Email*', 'Email*'),
                      labelStyle: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w600, fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.black, width: 2.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Nút Gửi
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isSending ? null : () async {
                        final email = resetEmailController.text.trim();
                        if (email.isEmpty || !email.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_t('Please enter a valid email.', 'Vui lòng nhập email hợp lệ.')),
                              backgroundColor: Colors.red.shade800,
                            ),
                          );
                          return;
                        }

                        setModalState(() => isSending = true); // Bật vòng xoay loading

                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                          if (mounted) {
                            Navigator.pop(context); // Đóng BottomSheet
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_t('Password reset link sent! Check your email.', 'Đã gửi liên kết đặt lại mật khẩu! Kiểm tra hộp thư của bạn.')),
                                backgroundColor: Colors.green.shade700,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          String errorMsg = _t('An error occurred', 'Đã xảy ra lỗi');
                          if (e.code == 'user-not-found') {
                            errorMsg = _t('No user found for that email.', 'Tài khoản email này không tồn tại.');
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red.shade800),
                          );
                        } finally {
                          if (mounted) setModalState(() => isSending = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        disabledBackgroundColor: Colors.grey.shade400,
                      ),
                      child: isSending
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              _t('Send Link', 'Gửi liên kết'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return; 

    if (!_isSignIn && !_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t('Please agree to the Terms of Use', 'Vui lòng đồng ý với Điều khoản sử dụng'))),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.black)),
    );

    try {
      if (_isSignIn) {
        // ─── XỬ LÝ ĐĂNG NHẬP ───
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        // --- XỬ LÝ REMEMBER ME ---
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString('saved_email', _emailController.text.trim());
        } else {
          await prefs.remove('saved_email');
        }
        
        if (mounted) Navigator.pop(context); 
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        }

      } else {
        // ─── XỬ LÝ ĐĂNG KÝ ───
        if (_passwordController.text != _confirmPasswordController.text) {
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_t('Passwords do not match', 'Mật khẩu xác nhận không khớp'))),
          );
          return;
        }

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        try {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "name": _nameController.text.trim(),
            "email": _emailController.text.trim(),
            "phone": _phoneController.text.trim(), 
            "avatar": "",
            "createdAt": FieldValue.serverTimestamp(),
          });
        } catch(e) {
          debugPrint("Lỗi lưu dữ liệu Firestore: $e");
        }
        
        if (mounted) Navigator.pop(context); 

        setState(() {
          _isSignIn = true; 
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_t('Registration successful! Please sign in.', 'Đăng ký thành công! Vui lòng đăng nhập lại.')),
              backgroundColor: Colors.green.shade700, 
            ),
          );
        }
      }

    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context); 
      String errorMsg = _isEnglish ? "An error occurred" : "Đã xảy ra lỗi";
      
      if (e.code == 'user-not-found') {
        errorMsg = _t('No user found for that email.', 'Tài khoản email này không tồn tại.');
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMsg = _t('Wrong password or email provided.', 'Email hoặc mật khẩu không chính xác.');
      } else if (e.code == 'email-already-in-use') {
        errorMsg = _t('The account already exists for that email.', 'Email này đã được đăng ký bởi người khác.');
      } else if (e.code == 'weak-password') {
        errorMsg = _t('The password provided is too weak.', 'Mật khẩu quá ngắn hoặc quá yếu.');
      } else if (e.code == 'invalid-email') {
        errorMsg = _t('The email address is badly formatted.', 'Định dạng email không hợp lệ.');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    }
  }

  Widget _buildTextField({
    required String labelEn, 
    required String labelVi, 
    required TextEditingController controller, 
    bool isPassword = false
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return _t('Required', 'Bắt buộc');
          }
          return null; 
        },
        decoration: InputDecoration(
          labelText: _t(labelEn, labelVi),
          labelStyle: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w600, fontSize: 16),
          
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5), 
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black, width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.red.shade900, width: 2.5),
          ),
          errorStyle: TextStyle(color: Colors.red.shade800, fontSize: 13, fontWeight: FontWeight.bold),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _isEnglish = !_isEnglish),
            icon: Icon(Icons.language, color: Colors.grey.shade900, size: 20),
            label: Text(
              _isEnglish ? 'VN' : 'EN',
              style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  AppLogo(type: LogoType.nikeBlack, width: 65),
                  SizedBox(width: 1), 
                  AppLogo(type: LogoType.jordanBlack, width: 75),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                _isSignIn 
                    ? _t('Enter your email.', 'Nhập email.') 
                    : _t('Join us to get the best of Nike.', 'Tham gia để nhận những điều tốt nhất từ Nike.'),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black, height: 1.2),
              ),
              
              const SizedBox(height: 30),

              if (_isSignIn) ...[
                _buildTextField(labelEn: 'Email*', labelVi: 'Email*', controller: _emailController),
                _buildTextField(labelEn: 'Password*', labelVi: 'Mật khẩu*', isPassword: true, controller: _passwordController),
                
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: Colors.black,
                      onChanged: (value) => setState(() => _rememberMe = value ?? false),
                    ),
                    Text(_t('Remember me', 'Ghi nhớ đăng nhập'), style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    
                    // GẮN SỰ KIỆN QUÊN MẬT KHẨU VÀO ĐÂY
                    GestureDetector(
                      onTap: _showForgotPasswordBottomSheet,
                      child: Text(
                        _t('Forgot Password?', 'Quên mật khẩu?'), 
                        style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],

              if (!_isSignIn) ...[
                _buildTextField(labelEn: 'Full Name*',labelVi: 'Họ và tên*',controller: _nameController,),
                _buildTextField(labelEn: 'Email*', labelVi: 'Email*', controller: _emailController),
                _buildTextField(labelEn: 'Phone Number*', labelVi: 'Số điện thoại*', controller: _phoneController),
                _buildTextField(labelEn: 'Password*', labelVi: 'Mật khẩu*', isPassword: true, controller: _passwordController),
                _buildTextField(labelEn: 'Confirm Password*', labelVi: 'Xác nhận mật khẩu*', isPassword: true, controller: _confirmPasswordController),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      activeColor: Colors.black,
                      onChanged: (value) => setState(() => _agreeTerms = value ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.grey.shade900, height: 1.5, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(text: _t("By continuing, I agree to Nike's ", "Bằng cách tiếp tục, tôi đồng ý với ")),
                              
                              TextSpan(
                                text: _t("Privacy Policy", "Chính sách bảo mật"), 
                                style: const TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                              ),
                              
                              TextSpan(text: _t(" and ", " và ")),
                              
                              TextSpan(
                                text: _t("Terms of Use", "Điều khoản sử dụng"), 
                                style: const TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsOfUseScreen())),
                              ),
                              const TextSpan(text: "."),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 40),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _handleAuth, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(_t('Continue', 'Tiếp tục'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _isSignIn = !_isSignIn),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(text: _isSignIn ? _t("Don't have an account? ", "Chưa có tài khoản? ") : _t("Already have an account? ", "Đã có tài khoản? ")),
                        TextSpan(
                          text: _isSignIn ? _t("Sign Up", "Đăng ký") : _t("Sign In", "Đăng nhập"),
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}