import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';
import 'home_screen.dart'; 
import 'shop_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Trạng thái: Thương hiệu (Nike/Jordan) & Tab hiện tại
  bool _isNike = true;
  int _currentIndex = 0;

  late List<Widget> _screens;

  late ScrollController _scrollController;
  bool _showSmallTitle = false;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo ScrollController để theo dõi thao tác cuộn của người dùng
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      
      // Nếu cuộn qua 10px -> Bật kính mờ
      if (offset > 10 && !_isScrolled) setState(() => _isScrolled = true);
      if (offset <= 10 && _isScrolled) setState(() => _isScrolled = false);
      
      // Nếu cuộn qua 80px -> Bật chữ Shop nhỏ ở giữa
      if (offset > 80 && !_showSmallTitle) setState(() => _showSmallTitle = true);
      if (offset <= 80 && _showSmallTitle) setState(() => _showSmallTitle = false);
    });

    _updateScreens();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScreens() {
    _screens = [
      const HomeScreen(), // Tab 1: Trang chủ
      ShopScreen(isNike: _isNike), // Tab 2: Shop
      _PlaceholderScreen(title: "Giỏ hàng (Bag)", isNike: _isNike),
      _PlaceholderScreen(title: "Hồ sơ (Profile)", isNike: _isNike),
    ];
  }

  void _toggleBrand() {
    setState(() {
      _isNike = !_isNike;
      _updateScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isNike ? Colors.white : Colors.black;
    final fgColor = _isNike ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. Nội dung trang chính nằm dưới cùng
          // Bọc PrimaryScrollController để các ListView bên trong tự động dùng chung Controller này
          PrimaryScrollController(
            controller: _scrollController,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_currentIndex],
            ),
          ),

          // 2. THANH KÍNH MỜ (Tự trong suốt khi ở trên cùng, hiện kính mờ khi cuộn)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top + 70,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isScrolled ? 1.0 : 0.0, // Chuyển đổi độ mờ
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    color: bgColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),

          // 3. CHỮ SHOP NHỎ Ở GIỮA (Fade in khi cuộn sâu xuống)
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _showSmallTitle ? 1.0 : 0.0, // Ẩn/Hiện mượt mà
              child: Center(
                child: Text(
                  _isNike ? "Shop" : "Shop Jordan",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: fgColor,
                  ),
                ),
              ),
            ),
          ),

          // 4. Nút gạt thương hiệu (Nike/Jordan)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: _buildBrandToggle(),
          ),

          // 5. Thanh điều hướng Floating ở dưới đáy
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildFloatingNavBar(fgColor, bgColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandToggle() {
    return GestureDetector(
      onTap: _toggleBrand,
      child: Container(
        width: 104,
        height: 40, // Đã giảm từ 46 xuống 40 cho nút thon gọn hơn
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _isNike ? Colors.grey.shade400 : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _isNike ? Colors.grey.shade500 : const Color(0xFF2C2C2C),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Cục highlight bọc quanh logo
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: _isNike ? 0 : 48, // Đã sửa lại thành 48 cho khít vừa vặn mép trong
              top: 0,
              bottom: 0,
              child: Container(
                width: 48,
                decoration: BoxDecoration(
                  color: _isNike ? const Color(0xFF333333) : Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            // Lớp Logo phủ lên trên
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        _isNike ? Colors.white : Colors.grey.shade500,
                        BlendMode.srcIn,
                      ),
                      child: const AppLogo(type: LogoType.nikeWhite, width: 30), // Logo Nike chuẩn size 30
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: const AppLogo(type: LogoType.jordanWhite, width: 46), // Logo Jordan 46 để lọt thỏm cân đối
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavBar(Color fgColor, Color bgColor) {
    return Row(
      children: [
        // Khối 4 nút chính
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: fgColor.withValues(alpha: 0.1), width: 1),
                ),
                child: Stack(
                  children: [
                    // Cục highlight nền trượt béo lên và bo tròn (Squircle)
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      // Dàn đều 4 nút từ -1.0 đến 1.0
                      alignment: Alignment(-1.0 + (_currentIndex * (2 / 3)), 0),
                      child: FractionallySizedBox(
                        widthFactor: 0.25, // Chiếm 1/4 chiều rộng thanh
                        heightFactor: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8), 
                          child: Container(
                            decoration: BoxDecoration(
                              color: fgColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(22), // Bo góc mềm mại
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Lớp Icon và chữ nổi lên trên
                    Row(
                      children: [
                        Expanded(child: _navItem(0, Icons.home_outlined, Icons.home, "Home", fgColor)),
                        Expanded(child: _navItem(1, Icons.sell_outlined, Icons.sell, "Shop", fgColor)),
                        Expanded(child: _navItem(2, Icons.shopping_bag_outlined, Icons.shopping_bag, "Bag", fgColor, hasBadge: false)),
                        Expanded(child: _navItem(3, Icons.person_outline, Icons.person, "Profile", fgColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Khối nút Tìm kiếm
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: fgColor.withValues(alpha: 0.1), width: 1),
                ),
                child: Icon(Icons.search, color: fgColor, size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navItem(int index, IconData iconOutlined, IconData iconFilled, String label, Color fgColor, {bool hasBadge = false}) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(isSelected ? iconFilled : iconOutlined, color: fgColor, size: 26),
                if (hasBadge)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  )
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: fgColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ==========================================
/// COMPONENT: Màn hình trống tạm thời
/// ==========================================
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final bool isNike;

  const _PlaceholderScreen({required this.title, required this.isNike});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isNike ? Colors.white : Colors.black,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isNike ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}