import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

import '../models/shoe_model.dart';

class DetailScreen extends StatelessWidget {
  final Shoe shoe;

  const DetailScreen({
    super.key,
    required this.shoe,
  });

  @override
  Widget build(BuildContext context) {
    final imageList = shoe.images.isNotEmpty ? shoe.images : [shoe.imageUrl];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          shoe.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 320,
              child: PageView.builder(
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: const Color(0xFFF8F8F8),
                    padding: const EdgeInsets.all(16),
                    child: _buildProductImage(imageList[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoe.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${shoe.brand} • ${shoe.category}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'đ${shoe.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    shoe.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.toLowerCase().startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 60,
            color: Colors.grey,
          ),
        ),
      );
    }

    if (imageUrl.toLowerCase().endsWith('.avif')) {
      return AvifImage.asset(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 60,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }
}
