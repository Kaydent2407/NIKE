import 'package:flutter/material.dart';
import '../models/shoe_model.dart';
import '../providers/cart_provider.dart';
import '../services/nike_service.dart'; // Đảm bảo đã import NikeService
// Import provider
import '../providers/favorite_provider.dart';

class DetailScreen extends StatefulWidget {
  final Shoe shoe;

  const DetailScreen({
    super.key,
    required this.shoe,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentImageIndex = 0;
  String? _selectedSize = "EU 36.5";
  bool _isFavorite = false;
  
  // Khai báo biến Future để gọi API
  late Future<List<Shoe>> recommendedShoes;

  final List<String> _sizes = [
    "EU 35.5",
    "EU 36.5",
    "EU 38",
    "EU 39",
    "EU 40",
    "EU 41",
  ];
  
  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh sách sản phẩm khi màn hình được tạo
    recommendedShoes = NikeService.fetchShoes();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = (widget.shoe.images != null && widget.shoe.images!.isNotEmpty)
        ? widget.shoe.images!
        : [widget.shoe.imageUrl];
    final favoriteProvider = FavoriteProvider();
    final isFav = favoriteProvider.isFavorite(widget.shoe);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          widget.shoe.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.ios_share, color: Colors.black, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CAROUSEL HÌNH ẢNH SẢN PHẨM
            SizedBox(
              height: 320,
              child: PageView.builder(
                itemCount: imageList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    color: const Color(0xFFFAFAFA),
                    padding: const EdgeInsets.all(20),
                    child: Image.network(
                      imageList[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.style, size: 100, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // INDICATOR CHẤM TRÒN
            if (imageList.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageList.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentImageIndex == index ? 8 : 6,
                    height: _currentImageIndex == index ? 8 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Colors.black
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // 2. THÔNG TIN SẢN PHẨM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shoe.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.shoe.category ?? "Women's Mules",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "đ${widget.shoe.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 3. CHỌN SIZE & SIZE GUIDE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Size",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Icon(Icons.straighten, size: 18, color: Colors.black),
                        SizedBox(width: 6),
                        Text(
                          "Size Guide",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _sizes.length,
                itemBuilder: (context, index) {
                  final size = _sizes[index];
                  final isSelected = _selectedSize == size;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSize = size;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        size,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // 4. NÚT ADD TO BAG & FAVORITE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        CartProvider().addToCart(widget.shoe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to Bag"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        "Add to Bag",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Nút Favorite trong _DetailScreenState:
SizedBox(
  width: double.infinity,
  height: 56,
  child: OutlinedButton(
    onPressed: () {
      setState(() {
        favoriteProvider.toggleFavorite(widget.shoe);
      });
    },
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isFav ? "Favorited" : "Favorite",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : Colors.black,
          size: 20,
        ),
      ],
    ),
  ),
),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "This product is excluded from all promotions and discounts.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),

            // 5. MÔ TẢ CHI TIẾT SẢN PHẨM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shoe.description ??
                        "The Air Jordan Mule combines a classic loafer upper, a soft foam platform and heritage Jordan style. What you get is a sleek and comfortable shoe that's solid enough for everyday wear. Rubber sidewalls give you a chunky look while premium hardware adds an elegant touch.",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _bulletPoint("Shown: Off-Noir/Chalk/Metallic Gold"),
                  _bulletPoint("Style: IV5070-001"),
                  _bulletPoint("Country/Region of Origin: Vietnam"),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "View Product Details",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Divider(height: 1, thickness: 0.5),

            // 6. ACCORDION (SIZE & FIT, REVIEWS)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  ExpansionTile(
                    title: const Text(
                      "Size & Fit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Text(
                          "Fits true to size. We recommend ordering your normal size.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  const Divider(height: 1, thickness: 0.5),
                  ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Reviews (2)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Text(
                          "Great product! Extremely comfortable and stylish.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 32),

            Center(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.black, size: 18),
                label: const Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 7. MỤC "YOU MIGHT ALSO LIKE" (DỮ LIỆU TỪ API)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "You Might Also Like",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 16),

            FutureBuilder<List<Shoe>>(
              future: recommendedShoes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 260,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox.shrink(); // Ẩn section nếu không có data
                }

                // Lọc bỏ sản phẩm hiện tại đang xem và lấy 5 sản phẩm đầu tiên
                final suggestedItems = snapshot.data!
                    .where((shoe) => shoe.title != widget.shoe.title)
                    .take(5)
                    .toList();

                return SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: suggestedItems.length,
                    itemBuilder: (context, index) {
                      final item = suggestedItems[index];
                      
                      return GestureDetector(
                        onTap: () {
                          // Điều hướng sang trang DetailScreen của sản phẩm được gợi ý
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(shoe: item),
                            ),
                          );
                        },
                        child: Container(
                          width: 170,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    fit: BoxFit.cover, // Hoặc BoxFit.contain tùy API
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.style, size: 60, color: Colors.grey.shade400),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.category ?? "Shoes",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "đ${item.price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}