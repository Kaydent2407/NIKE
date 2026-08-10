import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/shoe_model.dart';
import '../providers/favorite_provider.dart';
import '../utils/currency_formatter.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isEditing = false;
  final FavoriteProvider _favoriteProvider = FavoriteProvider();

  @override
  void initState() {
    super.initState();
    _favoriteProvider.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoriteProvider.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    setState(() {});
  }

  Future<List<dynamic>> fetchShoesFromAPI() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/category/mens-shoes'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['products'] ?? [];
    } else {
      throw Exception('Không thể tải danh sách sản phẩm');
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _favoriteProvider.favoriteShoes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F5F5),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(
                  _isEditing ? 'Done' : 'Edit',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // DANH SÁCH YÊU THÍCH HOẶC EMPTY STATE
            if (favorites.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Items added to your Favorites will be\nsaved here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final shoe = favorites[index];
                  return _buildFavoriteItem(shoe);
                },
              ),
            ],

            const SizedBox(height: 30),
            const Divider(indent: 20, endIndent: 20, thickness: 0.8),
            const SizedBox(height: 20),

            // TIÊU ĐỀ GỢI Ý
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Find Your Next Favorite',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // DANH SÁCH GỢI Ý TỪ API
            FutureBuilder<List<dynamic>>(
              future: fetchShoesFromAPI(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Lỗi: ${snapshot.error}'),
                  );
                }

                final shoes = snapshot.data ?? [];

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: shoes.length,
                  itemBuilder: (context, index) {
                    final shoe = shoes[index];
                    return _buildApiShoeItem(shoe);
                  },
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // WIDGET HIỂN THỊ ITEM YÊU THÍCH
  Widget _buildFavoriteItem(Shoe shoe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(shoe: shoe)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    shoe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.style, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      _favoriteProvider.removeFavorite(shoe);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            shoe.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            shoe.category ?? "Shoes",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(shoe.price),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HIỂN THỊ ITEM GỢI Ý TỪ API
  Widget _buildApiShoeItem(Map<String, dynamic> shoeMap) {
    final String rawImageUrl = shoeMap['thumbnail'] ??
        (shoeMap['images'] != null && (shoeMap['images'] as List).isNotEmpty
            ? shoeMap['images'][0]
            : '');

    final String imageUrl = rawImageUrl.isNotEmpty
        ? "https://corsproxy.io/?" + Uri.encodeComponent(rawImageUrl)
        : '';

    final shoeObj = Shoe(
      id: shoeMap['id'] is int 
          ? shoeMap['id'] 
          : int.tryParse(shoeMap['id']?.toString() ?? '') ?? 0,
      title: shoeMap['title'] ?? 'Nike Shoe',
      description: shoeMap['description'] ?? '', // <-- BỔ SUNG DÒNG NÀY
      imageUrl: imageUrl,
      price: (shoeMap['price'] ?? 0).toDouble() * 25000,
      category: shoeMap['category'] ?? 'Shoes',
      brand: shoeMap['brand'] ?? 'Nike',
      images: (shoeMap['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [imageUrl],
    );
    

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(shoe: shoeObj)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, color: Colors.grey),
                    )
                  : const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            shoeObj.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            shoeObj.category ?? 'Shoes',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyFormatter.format(shoeObj.price),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}