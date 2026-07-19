import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/shoe_model.dart';


class NikeService {


  static Future<List<Shoe>> fetchShoes() async {


    final url = Uri.parse(
        "https://dummyjson.com/products/category/mens-shoes"
    );


    final response = await http.get(url);



    if(response.statusCode == 200){


      final data = jsonDecode(response.body);


      List products = data['products'];



      return products
          .map((json)=> Shoe.fromJson(json))
          .toList();


    }else{

      throw Exception(
          "Không thể tải sản phẩm"
      );

    }

  }



}