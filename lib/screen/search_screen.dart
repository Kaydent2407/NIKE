import 'package:flutter/material.dart';

import '../data/local_product_data.dart';
import '../models/shoe_model.dart';
import '../services/nike_service.dart';
import '../widgets/shoe_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Shoe>> _allProductsFuture;
  String _searchQuery = '';

  // Danh sách các từ khóa gợi ý
  final List<String> _trendingSearches = [
    "Air Force 1",
    "Jordan",
    "Air Max",
    "Hoodie",
    "Dunk",
    "Bag"
  ];

  @override
  void initState() {
    super.initState();
    // Vừa vào trang là đi gom dữ liệu từ cả 2 nguồn (API + Local) ngay
    _allProductsFuture = _fetchAllProducts();
  }

  Future<List<Shoe>> _fetchAllProducts() async {
    try {
      // Chạy song song cả 2 để tiết kiệm thời gian
      final apiShoesFuture = NikeService.fetchShoes();
      final localProducts = LocalProductData.mockProducts();
      
      final apiShoes = await apiShoesFuture;
      
      // Nối 2 mảng lại với nhau
      return [...apiShoes, ...localProducts];
    } catch (e) {
      // Nếu API lỗi rớt mạng thì vẫn hiện hàng Local
      return LocalProductData.mockProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. THANH TÌM KIẾM (SEARCH BAR)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true, // Tự động bật bàn phím
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search, color: Colors.black),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. KẾT QUẢ TÌM KIẾM HOẶC GỢI Ý
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildTrendingSearches()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  // Giao diện khi chưa gõ từ khóa: Hiện các cụm từ tìm kiếm phổ biến
  Widget _buildTrendingSearches() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _trendingSearches.map((term) {
              return GestureDetector(
                onTap: () {
                  // Bấm vào gợi ý -> Tự động điền vào thanh search
                  _searchController.text = term;
                  setState(() {
                    _searchQuery = term.toLowerCase();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    term,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Giao diện khi đã gõ từ khóa: Lọc và hiện lưới sản phẩm
  Widget _buildSearchResults() {
    return FutureBuilder<List<Shoe>>(
      future: _allProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Đã có lỗi xảy ra."));
        }

        final allData = snapshot.data!;
        
        // Logic Lọc (Filter): Tìm theo Tên (title) hoặc Danh mục (category)
        final filteredData = allData.where((product) {
          final titleMatch = product.title.toLowerCase().contains(_searchQuery);
          final categoryMatch = product.category?.toLowerCase().contains(_searchQuery) ?? false;
          return titleMatch || categoryMatch;
        }).toList();

        if (filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  "We couldn't find anything for '$_searchQuery'",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 30),
          itemCount: filteredData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 12,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final product = filteredData[index];
            return ShoeCard(
              shoe: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(shoe: product),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}