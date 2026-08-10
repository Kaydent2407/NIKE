import 'package:flutter/material.dart';
import 'all_shoes_screen.dart';

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

  List<Widget> _buildTabContent(Color fgColor) {
    final int tabIndex = _tabController.index;
    
    // Tạo một danh sách rỗng để linh hoạt nhét số lượng banner tùy ý
    List<Widget> contentWidgets = [];

    // -----------------------------
    // NỘI DUNG CHO TỪNG BRAND VÀ TAB
    // -----------------------------
    if (widget.isNike) {
      // ===== NIKE (Gồm 2 banner) =====
      String shoesImg = '';
      String clothingImg = '';

      if (tabIndex == 0) { // Men
        shoesImg = 'assets/bannermenshoes.jpg';
        clothingImg = 'assets/bannermenacs.jpg';
      } else if (tabIndex == 1) { // Women
        shoesImg = 'assets/bannerwomenshoes.jpg';
        clothingImg = 'assets/bannerwomenacs.jpg';
      } else { // Kids
        shoesImg = 'assets/bannerkidshoes.jpg';
        clothingImg = 'assets/bannerkidacs.jpg';
      }

      contentWidgets.addAll([
        _ExpandableBanner(
          key: ValueKey('shoes_nike_$tabIndex'),
          imagePath: shoesImg, 
          isNike: true,
          items: const ['All Shoes'], 
          onItemTap: (item) {
            if (item == "All Shoes") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AllShoesScreen()));
            }
          },
        ),
        _ExpandableBanner(
          key: ValueKey('clothing_nike_$tabIndex'),
          imagePath: clothingImg, 
          isNike: true,
          items: const ['All Clothing'], 
        ),
      ]);

    } else {
      // ===== JORDAN (Gồm 3 banner) =====
      if (tabIndex == 0) { 
        // 1. Tab Streetwear: Men, Women, Kids cách nhau 1 khoảng trống
        contentWidgets.addAll([
          _ExpandableBanner(
            key: const ValueKey('jd_sw_men'),
            imagePath: 'assets/jdmen.jpg',
            isNike: false,
            items: const ['All Men\'s'],
          ),
          const SizedBox(height: 4), // Khoảng đen be bé
          _ExpandableBanner(
            key: const ValueKey('jd_sw_women'),
            imagePath: 'assets/jdwomen.jpg',
            isNike: false,
            items: const ['All Women\'s'],
          ),
          const SizedBox(height: 4), // Khoảng đen be bé
          _ExpandableBanner(
            key: const ValueKey('jd_sw_kids'),
            imagePath: 'assets/jdkid.jpg',
            isNike: false,
            items: const ['All Kids\''],
          ),
        ]);
      } else { 
        // 2. Tab Sport: Clothing, Shoes, Accessories
        contentWidgets.addAll([
          _ExpandableBanner(
            key: const ValueKey('jd_sp_clothing'),
            imagePath: 'assets/jdclothing.jpg',
            isNike: false,
            items: const ['All Clothing'],
          ),
          const SizedBox(height: 4),
          _ExpandableBanner(
            key: const ValueKey('jd_sp_shoes'),
            imagePath: 'assets/jdshoes.jpg',
            isNike: false,
            items: const ['All Shoes'],
            onItemTap: (item) {
              if (item == "All Shoes") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AllShoesScreen()));
              }
            },
          ),
          const SizedBox(height: 4),
          _ExpandableBanner(
            key: const ValueKey('jd_sp_acces'),
            imagePath: 'assets/jdacces.jpg',
            isNike: false,
            items: const ['All Accessories'],
          ),
        ]);
      }
    }

    // -----------------------------
    // THÊM PHẦN SẢN PHẨM Ở CUỐI TRANG
    // -----------------------------
    contentWidgets.addAll([
      const SizedBox(height: 30),
      SectionHeader(
        title: widget.isNike ? 'National Team Collections' : 'Jordan Exclusives', 
        color: fgColor
      ),
      const SizedBox(height: 15),
      SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            ProductCard(
              imageUrl: 'https://images.unsplash.com/photo-1584735174965-48c48d7028a9',
              title: widget.isNike ? 'French Artistry' : 'Retro Collection',
              fgColor: fgColor,
            ),
            ProductCard(
              imageUrl: 'https://images.unsplash.com/photo-1552346154-21d5981057c5',
              title: widget.isNike ? 'Mercurial Scorpion' : 'Flight Edition',
              fgColor: fgColor,
            ),
          ],
        ),
      ),
    ]);

    return contentWidgets;
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

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Color fgColor;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
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
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                color: fgColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
          // ASPECT RATIO 3.3 GIÚP ẢNH HIỂN THỊ 100% TỈ LỆ GỐC
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