import 'package:flutter/material.dart';

class NewsUpdate {
  final String title;
  final String description;
  final String imageUrl;
  final String category;

  NewsUpdate({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<NewsUpdate> _news = [
    NewsUpdate(
      title: "One on Anyone",
      description: "Jordan Brand's global tournament to crown the best 1-on-1 players in the world. The One returns in summer 2026.",
      imageUrl: "https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=1000",
      category: "JUMPMAN",
    ),
    NewsUpdate(
      title: "Air Max 2026",
      description: "Experience the next generation of cushioning. Lighter, more responsive, and designed for every stride.",
      imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=1000",
      category: "NIKE AIR",
    ),
    NewsUpdate(
      title: "Paris Collection",
      description: "Streetwear meets athletic performance. Inspired by the city of lights, designed for the streets.",
      imageUrl: "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000",
      category: "LIFESTYLE",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _news.length,
        itemBuilder: (context, index) {
          final item = _news[index];
          return Stack(
            children: [
              // 1. Hình ảnh nền full màn hình + Xử lý lỗi nếu tải ảnh thất bại
              Positioned.fill(
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Center(child: Icon(Icons.error, color: Colors.white)),
                    );
                  },
                ),
              ),
              
              // 2. Lớp phủ Gradient chuẩn với withOpacity (Tương thích mọi phiên bản)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8), // Sửa ở đây
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Explore",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}