import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

import '../data/local_product_data.dart';
import '../models/shoe_model.dart';
import '../utils/currency_formatter.dart';
import 'detail_screen.dart';
import 'product_list_screen.dart';

class ShopScreen extends StatefulWidget {
  final bool isNike;

  const ShopScreen({
    super.key,
    required this.isNike,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.isNike ? 3 : 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    setState(() {}); 
  }

  @override
  void didUpdateWidget(ShopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isNike != widget.isNike) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();
      
      _tabController = TabController(length: widget.isNike ? 3 : 2, vsync: this);
      _tabController.addListener(_handleTabSelection);
      setState(() {}); 
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _activeGender {
    switch (_tabController.index) {
      case 0:
        return 'Men';
      case 1:
        return 'Women';
      case 2:
        return 'Kids';
      default:
        return 'Men';
    }
  }

  List<Widget> _buildTabContent(Color fgColor) {
    final int tabIndex = _tabController.index;
    List<Widget> contentWidgets = [];

    // Gọi kho dữ liệu Local
    final allLocalProducts = LocalProductData.mockProducts();
    
    String featuredTitle = '';
    List<Widget> featuredWidgets = [];

    if (widget.isNike) {
      String shoesImg = '';
      String clothingImg = '';

      if (tabIndex == 0) { // MEN
        shoesImg = 'assets/bannermenshoes.jpg';
        clothingImg = 'assets/bannermenacs.jpg';
        
        featuredTitle = 'Trending for Men';
        // Tự động lấy 4 sản phẩm của Nam
        final featuredShoes = allLocalProducts.where((p) => p.gender == 'Men').take(4).toList();
        featuredWidgets = featuredShoes.map((shoe) => _buildClickableCard(shoe, fgColor)).toList();
        
      } else if (tabIndex == 1) { // WOMEN
        shoesImg = 'assets/bannerwomenshoes.jpg';
        clothingImg = 'assets/bannerwomenacs.jpg';

        featuredTitle = 'Trending for Women';
        // Tự động lấy 4 sản phẩm của Nữ
        final featuredShoes = allLocalProducts.where((p) => p.gender == 'Women').take(4).toList();
        featuredWidgets = featuredShoes.map((shoe) => _buildClickableCard(shoe, fgColor)).toList();

      } else { // KIDS
        shoesImg = 'assets/bannerkidshoes.jpg';
        clothingImg = 'assets/bannerkidacs.jpg';

        featuredTitle = 'Trending for Kids';
        // Tự động lấy 4 sản phẩm của Trẻ em
        final featuredShoes = allLocalProducts.where((p) => p.gender == 'Kids').take(4).toList();
        featuredWidgets = featuredShoes.map((shoe) => _buildClickableCard(shoe, fgColor)).toList();
      }

      final gender = _activeGender;

      contentWidgets.addAll([
        _ExpandableBanner(
          key: ValueKey('shoes_nike_$tabIndex'),
          imagePath: shoesImg,
          isNike: true,
          items: const ['All Shoes'],
          onItemTap: (item) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(
                  category: item,
                  gender: gender,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        _ExpandableBanner(
          key: ValueKey('clothing_nike_$tabIndex'),
          imagePath: clothingImg,
          isNike: true,
          items: const [
            'All Clothing',
            'Tops & T-Shirts',
            'Hoodies & Pullovers',
            'Jackets',
            'Shorts',
            'Socks',
          ],
          onItemTap: (item) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(
                  category: item,
                  gender: gender,
                ),
              ),
            );
          },
        ),
      ]);
    } else {
      if (tabIndex == 0) { // STREETWEAR
        featuredTitle = 'Streetwear Exclusives';
        // Lấy ngẫu nhiên vài sản phẩm làm nổi bật
        final featuredShoes = allLocalProducts.where((p) => p.category == 'Hoodies & Pullovers').take(4).toList();
        featuredWidgets = featuredShoes.map((shoe) => _buildClickableCard(shoe, fgColor)).toList();

        contentWidgets.addAll([
          _ExpandableBanner(
            key: const ValueKey('jd_sw_men'),
            imagePath: 'assets/jdmen.jpg',
            isNike: false,
            items: const ['All Men\'s'],
            onItemTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    category: item,
                    gender: 'Men',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          _ExpandableBanner(
            key: const ValueKey('jd_sw_women'),
            imagePath: 'assets/jdwomen.jpg',
            isNike: false,
            items: const ['All Women\'s'],
            onItemTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    category: item,
                    gender: 'Women',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          _ExpandableBanner(
            key: const ValueKey('jd_sw_kids'),
            imagePath: 'assets/jdkid.jpg',
            isNike: false,
            items: const ['All Kids'],
            onItemTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    category: item,
                    gender: 'Kids',
                  ),
                ),
              );
            },
          ),
        ]);
      } else { // SPORT
        featuredTitle = 'Performance Gear';
        final featuredShoes = allLocalProducts.where((p) => p.category == 'Shorts').take(4).toList();
        featuredWidgets = featuredShoes.map((shoe) => _buildClickableCard(shoe, fgColor)).toList();

        contentWidgets.addAll([
          _ExpandableBanner(
            key: const ValueKey('jd_sp_clothing'),
            imagePath: 'assets/jdclothing.jpg',
            isNike: false,
            items: const ['All Clothing'],
            onItemTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    category: item,
                    gender: 'All',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          _ExpandableBanner(
            key: const ValueKey('jd_sp_shoes'),
            imagePath: 'assets/jdshoes.jpg',
            isNike: false,
            items: const ['All Shoes'],
            onItemTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    category: item,
                    gender: 'All',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          _ExpandableBanner(
            key: const ValueKey('jd_sp_acces'),
            imagePath: 'assets/jdacces.jpg',
            isNike: false,
            items: const ['All Accessories'],
            onItemTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    category: item,
                    gender: 'All',
                  ),
                ),
              );
            },
          ),
        ]);
      }
    }

    // HIỂN THỊ PHẦN SẢN PHẨM NỔI BẬT Ở CUỐI TRANG
    contentWidgets.addAll([
      const SizedBox(height: 30),
      SectionHeader(title: featuredTitle, color: fgColor),
      const SizedBox(height: 15),
      SizedBox(
        height: 240, // Tăng nhẹ chiều cao để không bị cấn giá tiền
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: featuredWidgets, 
        ),
      ),
    ]);

    return contentWidgets;
  }

  // Hàm hỗ trợ tạo ProductCard có thể click được
  Widget _buildClickableCard(Shoe shoe, Color fgColor) {
    return ProductCard(
      shoe: shoe,
      fgColor: fgColor,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(shoe: shoe),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fgColor = widget.isNike ? Colors.black : Colors.white;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 70),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.isNike ? 'Shop' : 'Shop Jordan',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: fgColor,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TabBar(
            controller: _tabController,
            isScrollable: true, 
            tabAlignment: TabAlignment.start, 
            labelColor: fgColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: fgColor,
            indicatorSize: TabBarIndicatorSize.label, 
            dividerColor: Colors.transparent, 
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            tabs: widget.isNike
                ? const [
                    Tab(text: 'Men'),
                    Tab(text: 'Women'),
                    Tab(text: 'Kids'),
                  ]
                : const [
                    Tab(text: 'Streetwear'),
                    Tab(text: 'Sport'),
                  ],
          ),
        ),
        const SizedBox(height: 10),
        
        ..._buildTabContent(fgColor),
        
        const SizedBox(height: 120), 
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeader({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

// BẢN NÂNG CẤP PRODUCT CARD ĐỂ NHẬN DỮ LIỆU THẬT & AVIF
class ProductCard extends StatelessWidget {
  final Shoe shoe;
  final Color fgColor;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.shoe,
    required this.fgColor,
    required this.onTap,
  });

  Widget _buildImage() {
    if (shoe.imageUrl.toLowerCase().startsWith('http')) {
      return Image.network(
        shoe.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.style, size: 40, color: Colors.grey),
      );
    }
    if (shoe.imageUrl.toLowerCase().endsWith('.avif')) {
      return AvifImage.asset(
        shoe.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.style, size: 40, color: Colors.grey),
      );
    }
    return Image.asset(
      shoe.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.style, size: 40, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildImage(),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                shoe.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: fgColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(shoe.price),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableBanner extends StatefulWidget {
  final String imagePath;
  final bool isNike;
  final List<String> items;
  final Function(String)? onItemTap;

  const _ExpandableBanner({
    super.key,
    required this.imagePath,
    required this.isNike,
    required this.items,
    this.onItemTap,
  });

  @override
  State<_ExpandableBanner> createState() => _ExpandableBannerState();
}

class _ExpandableBannerState extends State<_ExpandableBanner> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final fgColor = widget.isNike ? Colors.black : Colors.white;
    final bgColor = widget.isNike ? Colors.white : Colors.black;
    final dividerColor = widget.isNike ? Colors.grey.shade300 : Colors.grey.shade800;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: AspectRatio(
            aspectRatio: 3.3, 
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imagePath),
                  fit: BoxFit.cover, 
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: expanded
              ? Container(
                  color: bgColor,
                  child: Column(
                    children: widget.items.map((item) {
                      return InkWell(
                        onTap: () {
                          if (widget.onItemTap != null) {
                            widget.onItemTap!(item);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: dividerColor,
                              ),
                            ),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: fgColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}