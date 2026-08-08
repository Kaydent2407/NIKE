import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Import Firebase Auth
import '../widgets/app_logo.dart';
import 'main_navigation_screen.dart';
import 'auth_screen.dart'; // 2. Import AuthScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _showNikeLogo = true;
  late Timer _glitchTimer;
  late AnimationController _controller;
  
  // Các thông số cấu hình độ giật
  final Duration _glitchSpeed = const Duration(milliseconds: 400);
  double _currentScale = 1.0;
  double _currentRotation = 0.0;

  @override
  void initState() {
    super.initState();

    // Khởi tạo bộ điều khiển để cập nhật lại giao diện khi giật
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // Tạo vòng lặp giật gắt liên tục
    _glitchTimer = Timer.periodic(_glitchSpeed, (timer) {
      if (!mounted) return;
      
      setState(() {
        _showNikeLogo = !_showNikeLogo;
        _currentScale = 1.1 + (math.Random().nextDouble() * 0.2);
      });

      _controller.forward(from: 0.0);
    });

    // Sau đúng 3 giây, kiểm tra trạng thái đăng nhập và chuyển màn hình
    Timer(const Duration(seconds: 3), () {
      _glitchTimer.cancel();
      _controller.dispose();
      
      if (!mounted) return;

      // 3. Kiểm tra user đã đăng nhập Firebase hay chưa
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Đã đăng nhập -> Chuyển sang màn hình chính
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else {
        // Chưa đăng nhập -> Chuyển sang màn hình đăng nhập / đăng ký
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _glitchTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double scaleEffect = _currentScale - (_controller.value * (_currentScale - 1.0));
            final double rotationEffect = _currentRotation - (_controller.value * _currentRotation);

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(scaleEffect)
                ..rotateZ(rotationEffect),
              child: _showNikeLogo
                  ? const AppLogo(type: LogoType.nikeWhite, width: 150)
                  : const AppLogo(type: LogoType.jordanWhite, width: 200),
            );
          },
        ),
      ),
    );
  }
}