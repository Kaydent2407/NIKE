import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';
import 'explore_screen.dart'; // Import trang Explore để chuyển qua

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Ảnh 1: Dùng làm bìa ngoài trang Home (Ví dụ: Hình nam ném bóng rổ)
  final String _coverImage = "assets/section1/8.jpg"; 
  
  // Ảnh 2: Dùng cho trang chi tiết bên trong (Ví dụ: Hình 2 người ngồi)
  // Bạn có thể đổi số 9.jpg thành file ảnh đúng của bạn
  final String _insideImage = "assets/section1/9.jpg"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        scrollDirection: Axis.vertical, // Lướt dọc
        children: [
          _buildSlideType1(context),
          // Sau này có nhiều bài viết thì bạn copy _buildSlideType1() ra làm nhiều cái
        ],
      ),
    );
  }

  Widget _buildSlideType1(BuildContext context) {
    return Stack(
      children: [
        // 1. Hình ảnh nền ngoài Home (_coverImage)
        Positioned.fill(
          child: Image.asset(
            _coverImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900]),
          ),
        ),
        
        // 2. Lớp phủ Gradient đen mờ
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),

        // 3. Nội dung chữ và Nút bấm
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo kéo sang trái 6px cho thẳng hàng
              Transform.translate(
                offset: const Offset(-6, 0),
                child: const ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  child: AppLogo(type: LogoType.jordanWhite, width: 28),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Dayo23 Collection",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Rep your culture with Luka 77 'Dayo23' and more.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              
              // ==========================================
              // NÚT EXPLORE: Bấm vào sẽ mở trang ExploreScreen
              // ==========================================
              GestureDetector(
                onTap: () {
                  // Mở trang chi tiết và truyền cái hình _insideImage vào
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExploreScreen(imageUrl: _insideImage),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Explore",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}