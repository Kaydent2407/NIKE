import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shoe_model.dart';

class ProductService {
  static const String baseUrl = 'https://dummyjson.com/products/category/mens-shoes';

  static Future<List<Shoe>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List products = data['products'] as List;
      return products
          .map((json) => Shoe.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Không tải được sản phẩm');
  }
}