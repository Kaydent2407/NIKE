import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  final bool isNike;

  const ShopScreen({super.key, required this.isNike});

  @override
  Widget build(BuildContext context) {
    final fgColor = isNike ? Colors.black : Colors.white;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 70),

        // 1. Tiêu đề
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            isNike ? 'Shop' : 'Shop Jordan',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: fgColor,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildTab(isNike ? 'Men' : 'Streetwear', isActive: true, fgColor: fgColor),
              const SizedBox(width: 24),
              _buildTab(isNike ? 'Women' : 'Sport', isActive: false, fgColor: fgColor),
              const SizedBox(width: 24),
              if (isNike) _buildTab('Kids', isActive: false, fgColor: fgColor),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. CÁC BANNER XỔ XUỐNG (ACCORDION)
        _ExpandableBanner(
          title: 'New & Featured',
          imageUrl: 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55', // Ảnh bóng đá
          isNike: isNike,
          items: const [
            'Nike Football',
            'App Exclusive & Early Access',
            'New & Upcoming Drops',
            'National Team Kits',
            'New Releases',
            'Bestsellers',
            'LeBron James',
            'Member Shop',
            'Top Picks Under 3,000,000đ'
          ],
        ),
        _ExpandableBanner(
          title: 'Shoes',
          imageUrl: 'https://images.unsplash.com/photo-1605348532760-6753d2c43329', // Ảnh giày cam đen
          isNike: isNike,
          items: const [
            'All Shoes',
            'Lifestyle',
            'Running',
            'Basketball',
            'Football',
            'Training & Gym',
            'Skateboarding'
          ],
        ),
        _ExpandableBanner(
          title: 'Clothing & Accessories',
          imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f', // Ảnh thời trang thể thao
          isNike: isNike,
          items: const [
            'All Clothing',
            'Tops & T-Shirts',
            'Shorts',
            'Hoodies & Pullovers',
            'Trousers & Tights',
            'Jackets',
            'Socks'
          ],
        ),
        _ExpandableBanner(
          title: 'Sale',
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', // Ảnh giày đỏ
          isNike: isNike,
          items: const [
            'Shop All Sale',
            'Shoes Sale',
            'Clothing Sale',
            'Accessories Sale'
          ],
        ),
        
        const SizedBox(height: 30),

        // 4. Các danh sách nằm ngang như cũ
        _buildSectionHeader('National Team Collections', fgColor),
        const SizedBox(height: 15),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              _buildProductCard(
                imageUrl: 'https://images.unsplash.com/photo-1584735174965-48c48d7028a9',
                title: 'French Artistry',
                fgColor: fgColor,
              ),
              _buildProductCard(
                imageUrl: 'https://images.unsplash.com/photo-1552346154-21d5981057c5',
                title: 'Mercurial Scorpion',
                fgColor: fgColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildTab(String text, {required bool isActive, required Color fgColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? fgColor : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        if (isActive) Container(height: 2, width: 30, color: fgColor)
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color fgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: fgColor)),
    );
  }

  Widget _buildProductCard({required String imageUrl, required String title, required Color fgColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: fgColor), maxLines: 2),
          ],
        ),
      ),
    );
  }
}

/// ========================================================
/// WIDGET TẠO BANNER HÌNH ẢNH CÓ THỂ XỔ XUỐNG ĐƯỢC
/// ========================================================
class _ExpandableBanner extends StatefulWidget {
  final String title;
  final String imageUrl;
  final bool isNike;
  final List<String> items;

  const _ExpandableBanner({
    required this.title,
    required this.imageUrl,
    required this.isNike,
    required this.items,
  });

  @override
  State<_ExpandableBanner> createState() => _ExpandableBannerState();
}

class _ExpandableBannerState extends State<_ExpandableBanner> {
  bool _isExpanded = false; // Biến theo dõi trạng thái đóng/mở

  @override
  Widget build(BuildContext context) {
    final fgColor = widget.isNike ? Colors.black : Colors.white;
    final bgColor = widget.isNike ? Colors.white : Colors.black;
    // Màu đường kẻ mờ ngăn cách giữa các item
    final dividerColor = widget.isNike ? Colors.grey.shade300 : Colors.grey.shade800;

    return Column(
      children: [
        // 1. Phần Banner Hình ảnh (Bấm vào để đóng/mở)
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            height: 120, // Chiều cao banner giống gốc
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.cover,
                // Phủ 1 lớp đen mờ 30% để làm nổi bật chữ màu trắng
                colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.3), BlendMode.darken),
              ),
              // Đường kẻ trắng mỏng giữa các banner để phân biệt
              border: const Border(bottom: BorderSide(color: Colors.white, width: 1)),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 22, 
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
        
        // 2. Phần Danh sách xổ xuống (Sử dụng AnimatedSize để làm hiệu ứng trượt mượt mà)
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut, // Hiệu ứng nhanh dần rồi chậm dần (smooth)
          child: _isExpanded
              ? Container(
                  color: bgColor, // Nền trắng(Nike) hoặc đen(Jordan)
                  child: Column(
                    children: widget.items.map((item) {
                      return Material( // Dùng Material và InkWell để tạo hiệu ứng bấm nhấp nháy
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Xử lý khi bấm vào từng mục (ví dụ chuyển qua trang list giày)
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                              // Viền dưới mỏng ngăn cách giữa các mục
                              border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: fgColor, 
                                fontSize: 16, 
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(width: double.infinity, height: 0), // Khi đóng thì thu chiều cao về 0
        ),
      ],
    );
  }
}