import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _showNikeLogo = true;
  late Timer _glitchTimer;
  late AnimationController _controller;
  
  // Các thông số cấu hình độ giật (Bạn có thể tự chỉnh lại theo ý muốn)
  final Duration _glitchSpeed = const Duration(milliseconds: 400); // Tốc độ giật (càng nhỏ càng nhanh)
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
        // 1. Đổi logo lập tức (Không fade)
        _showNikeLogo = !_showNikeLogo;
        
        // 2. Tạo độ phóng to giật mình ngẫu nhiên từ 1.1 đến 1.3
        _currentScale = 1.1 + (math.Random().nextDouble() * 0.2);
        
        // 3. Tạo góc xoay nghiêng giật mình ngẫu nhiên từ -15 đến +15 độ
        //_currentRotation = (math.Random().nextDouble() * 30 - 15) * math.pi / 180;
      });

      // Kích hoạt hiệu ứng co giãn giật về trạng thái gốc
      _controller.forward(from: 0.0);
    });

    // Sau đúng 3 giây, tắt hiệu ứng giật và chuyển thẳng vào HomeScreen
    Timer(const Duration(seconds: 3), () {
      _glitchTimer.cancel();
      _controller.dispose();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _glitchTimer.cancel();
    if (_controller.isAnimating || _controller.isCompleted) {    
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Nền đen premium tối giản
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Sử dụng các hàm nội suy biến đổi để tạo nhịp nhấp nháy gắt
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