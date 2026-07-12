import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/shoe_model.dart';

class NikeService {
  static const String _host = "nike-api.p.rapidapi.com";

  static const String _apiKey =
      "bfa4b94f93msh647026f4ce37519p1369a0jsn88d6d5cd32f3";

  String? _nextToken = "#SHOE#10002124";

  String? get nextToken => _nextToken;

  /// ===============================
  /// Lấy danh sách giày nữ
  /// ===============================
  Future<List<Shoe>> getWomenShoes() async {
    final uri = Uri.https(
      _host,
      "/get-womens-shoes",
      {
        if (_nextToken != null) "next_token": _nextToken!,
      },
    );

    print("REQUEST:");
    print(uri);

    final response = await http.get(
      uri,
      headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _host,
        "Content-Type": "application/json",
      },
    );

    print("STATUS : ${response.statusCode}");
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception(
          "Nike API Error : ${response.statusCode}\n${response.body}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    _nextToken = data["next_token"];

    final List list = data["items"] ?? [];

    return list.map((e) => Shoe.fromJson(e)).toList();
  }

  /// ===============================
  /// Load thêm sản phẩm
  /// ===============================
  Future<List<Shoe>> loadMore() async {
    if (_nextToken == null) {
      return [];
    }

    final uri = Uri.https(
      _host,
      "/get-womens-shoes",
      {
        "next_token": _nextToken!,
      },
    );

    print("LOAD MORE:");
    print(uri);

    final response = await http.get(
      uri,
      headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _host,
        "Content-Type": "application/json",
      },
    );

    print("STATUS : ${response.statusCode}");
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception(
          "Nike API Error : ${response.statusCode}\n${response.body}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    _nextToken = data["next_token"];

    final List list = data["items"] ?? [];

    return list.map((e) => Shoe.fromJson(e)).toList();
  }

  /// ===============================
  /// Chi tiết sản phẩm
  /// ===============================
  Future<Shoe?> getDetail(String productUrl) async {
    final uri = Uri.https(
      _host,
      "/get-womens-shoe-details",
      {
        "product_url": productUrl,
      },
    );

    print(uri);

    final response = await http.get(
      uri,
      headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _host,
        "Content-Type": "application/json",
      },
    );

    print(response.statusCode);

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);

    if (json is Map<String, dynamic>) {
      return Shoe.fromJson(json);
    }

    return null;
  }
}