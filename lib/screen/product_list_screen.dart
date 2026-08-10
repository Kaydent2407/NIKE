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
      return NikeService.fetchShoes();
    }

    final allProducts = LocalProductData.mockProducts();

    return allProducts.where((product) {
      final productGender = product.gender.toLowerCase();
      final productCategory = product.category.toLowerCase();
      final matchesGender = productGender == normalizedGender;
      final matchesCategory =
          normalizedCategory == 'all clothing' ||
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
        centerTitle: true,
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Shoe>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Không có sản phẩm cho ${widget.category}.'),
            );
          }

          final data = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.53,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
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
