import 'package:flutter/gestures.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // Thư viện lưu trữ dữ liệu máy
import 'package:cloud_firestore/cloud_firestore.dart'; // Thư viện Firestore

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
    _loadSavedEmail(); // Kích hoạt hàm kiểm tra xem có email nào được lưu không
  }

  // Hàm tải Email đã lưu từ lần đăng nhập trước
  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail; // Tự động điền email
        _rememberMe = true;                 // Tự động tick vào ô Remember me
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
          // Nếu có tick -> Lưu email vào máy
          await prefs.setString('saved_email', _emailController.text.trim());
        } else {
          // Nếu không tick -> Xóa email cũ đi
          await prefs.remove('saved_email');
        }
        
        if (mounted) Navigator.pop(context); // Tắt vòng loading
        
        // Đăng nhập xong -> Qua SplashScreen chạy hiệu ứng
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

        UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
);
    print("Đăng ký Auth OK");

try{
// Lưu thông tin người dùng vào Firestore
await FirebaseFirestore.instance
    .collection("users")
    .doc(userCredential.user!.uid)
    .set({

  "name": _nameController.text.trim(), // Tên người dùng
  "email": _emailController.text.trim(),
  "phone": _phoneController.text.trim(), // Nếu có ô nhập số điện thoại
  "avatar": "",
  "createdAt": FieldValue.serverTimestamp(),
});
print("Lưu dữ liệu Firestore OK");
}catch(e){
  print("Lỗi lưu dữ liệu Firestore: $e");}

        
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
                    Text(_t('Forgot Password?', 'Quên mật khẩu?'), style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
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