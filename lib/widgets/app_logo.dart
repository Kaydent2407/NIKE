import 'package:flutter/material.dart';

// Định nghĩa các loại logo bạn đang có
enum LogoType {
  nikeWhite,
  nikeBlack,
  jordanWhite,
  jordanBlack,
}

class AppLogo extends StatelessWidget {
  final LogoType type;
  final double width;

  const AppLogo({
    super.key,
    this.type = LogoType.nikeWhite, // Đặt mặc định là Nike trắng nếu không truyền gì
    this.width = 60, // Kích thước mặc định
  });

  // Hàm này sẽ tự động chọn đúng tên file dựa trên enum bạn chọn
  String _getLogoPath() {
    switch (type) {
      case LogoType.nikeWhite:
        return 'assets/logo_nike_white.png';
      case LogoType.nikeBlack:
        return 'assets/logo_nike_black.png';
      case LogoType.jordanWhite:
        return 'assets/logo_jordan_white.png';
      case LogoType.jordanBlack:
        return 'assets/logo_jordan_black.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _getLogoPath(),
      width: width,
      fit: BoxFit.contain,
      // Phòng trường hợp gõ sai tên file, nó sẽ hiện một icon lỗi thay vì làm sập app
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image, size: width, color: Colors.grey);
      },
    );
  }
}