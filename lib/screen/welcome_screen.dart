import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/app_logo.dart'; // Import Logo của bạn (sửa đường dẫn nếu cần)
import 'auth_screen.dart';         // Import màn hình đăng nhập/đăng ký vừa tạo

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentPage = 0;
  Timer? _timer;

  // Danh sách ảnh nền (Background)
  final List<String> _bgImages = [
    'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1514989940723-e8e51635b782?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Giày Air Max
    'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Người chạy bộ
  ];

  @override
  void initState() {
    super.initState();
    // Chuyển ảnh mượt mà mỗi 4 giây
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      setState(() {
        if (_currentPage < _bgImages.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Phải tắt Timer khi chuyển sang trang khác để không bị lỗi
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Hình nền với hiệu ứng Cross-fade (Mờ dần)
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Image.network(
                _bgImages[_currentPage],
                key: ValueKey<int>(_currentPage),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // 2. Lớp gradient mờ đen ở đáy để nổi bật chữ
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 3. Nội dung chính: Logo, Text, Dots, Nút bấm
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Logo Nike Trắng
                  const AppLogo(type: LogoType.nikeWhite, width: 70),
                  const SizedBox(height: 20),
                  
                  // Text giới thiệu
                  const Text(
                    'Bringing Nike Members\nthe best products, inspiration\nand stories in sport.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Thanh Indicator (Dấu chấm chuyển ảnh)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      _bgImages.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Hai nút bấm: Sign Up & Sign In
                  Row(
                    children: [
                      // Nút SIGN UP (Đăng ký)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Chuyển sang màn hình Auth ở chế độ Đăng Ký (isInitialSignIn = false)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(isInitialSignIn: false),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Nút SIGN IN (Đăng nhập)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Chuyển sang màn hình Auth ở chế độ Đăng Nhập (isInitialSignIn = true)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(isInitialSignIn: true),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget tạo các dấu chấm chỉ thị trang (Indicator)
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}