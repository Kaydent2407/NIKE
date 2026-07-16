import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';


class ExploreScreen extends StatelessWidget {
  final String imageUrl;

  const ExploreScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Nửa trên: Hình ảnh (chiếm 55% màn hình)
          Expanded(
            flex: 55,
            child: Stack(
              children: [
                // Ảnh nền (nhận từ trang Home truyền qua, đổi thành Image.asset)
                Positioned.fill(
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900]),
                  ),
                ),
                
                // Nút Back và Share ở góc trên
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nút mũi tên lùi (Bấm để quay lại Home)
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Lệnh quay lại trang trước
                          },
                          child: _buildIconButton(Icons.arrow_back_ios_new_rounded, size: 18),
                        ),
                        // Nút Share
                        _buildIconButton(Icons.ios_share_rounded, size: 22),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nửa dưới: Nền đen, Chữ căn giữa (chiếm 45% màn hình)
          Expanded(
            flex: 45,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // Logo Jordan căn giữa
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: AppLogo(type: LogoType.jordanWhite, width: 36),
                  ),
                  SizedBox(height: 24),
                  
                  // Đoạn text to
                  Text(
                    "The Luka 77\n'Dayo23' turns\nevery court into\nyour home court.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 20), // Đẩy chữ lên xíu cho cân đối
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget tạo nút tròn mờ mờ trên ảnh
  Widget _buildIconButton(IconData icon, {double size = 20}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2), 
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}