import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart'; // Import thư viện AVIF

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Trường hợp 1: Ảnh từ API (link mạng)
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    }

    // Trường hợp 2: Ảnh Local đuôi .avif
    if (imageUrl.toLowerCase().endsWith('.avif')) {
      return AvifImage.asset(
        imageUrl,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    }

    // Trường hợp 3: Ảnh Local bình thường (.png, .jpg)
    return Image.asset(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}