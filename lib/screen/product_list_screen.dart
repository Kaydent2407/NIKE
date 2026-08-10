import 'package:flutter/material.dart';

import '../data/local_product_data.dart';
import '../models/shoe_model.dart';
import '../services/nike_service.dart';
import '../widgets/shoe_card.dart';
import 'detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String category;
  final String gender;

  const ProductListScreen({
    super.key,
    required this.category,
    required this.gender,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Shoe>> products;

  @override
  void initState() {
    super.initState();
    products = _loadProducts();
  }

  Future<List<Shoe>> _loadProducts() async {
    final normalizedCategory = widget.category.toLowerCase();
    final normalizedGender = widget.gender.toLowerCase();

    if (normalizedCategory == 'all shoes') {
      final allShoes = await NikeService.fetchShoes();
      if (normalizedGender == 'all') {
        return allShoes;
      }
      return allShoes
          .where((shoe) => shoe.gender.toLowerCase() == normalizedGender)
          .toList();
    }

    final allProducts = LocalProductData.mockProducts();
    final accessoriesCategories = ['bag', 'socks'];
    final shouldIgnoreCategory = normalizedCategory.startsWith('all ') &&
        normalizedCategory != 'all clothing' &&
        normalizedCategory != 'all accessories';

    return allProducts.where((product) {
      final productGender = product.gender.toLowerCase();
      final productCategory = product.category.toLowerCase();
      final matchesGender = normalizedGender == 'all' ||
          productGender == normalizedGender;

      final matchesCategory = normalizedCategory == 'all clothing' ||
          (normalizedCategory == 'all accessories' &&
              accessoriesCategories.contains(productCategory)) ||
          shouldIgnoreCategory ||
          productCategory == normalizedCategory;

      return matchesGender && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, 
        centerTitle: true,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF5F5F5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600, 
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF5F5F5),
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.black, size: 20),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      // Đẩy FutureBuilder ra làm body chính, không cần Column hay Expanded nữa
      body: FutureBuilder<List<Shoe>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Không có sản phẩm cho ${widget.category}.',
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          final data = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 30),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55, 
              crossAxisSpacing: 12,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              final product = data[index];
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
      ),
    );
  }
}