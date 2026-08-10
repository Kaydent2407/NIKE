import 'package:flutter/material.dart';
import '../models/shoe_model.dart';

class FavoriteProvider extends ChangeNotifier {
  static final FavoriteProvider _instance = FavoriteProvider._internal();
  factory FavoriteProvider() => _instance;
  FavoriteProvider._internal();

  final List<Shoe> _favoriteShoes = [];

  List<Shoe> get favoriteShoes => List.unmodifiable(_favoriteShoes);

  bool isFavorite(Shoe shoe) {
    return _favoriteShoes.any((item) => item.title == shoe.title);
  }

  void toggleFavorite(Shoe shoe) {
    if (isFavorite(shoe)) {
      _favoriteShoes.removeWhere((item) => item.title == shoe.title);
    } else {
      _favoriteShoes.add(shoe);
    }
    notifyListeners();
  }

  void removeFavorite(Shoe shoe) {
    _favoriteShoes.removeWhere((item) => item.title == shoe.title);
    notifyListeners();
  }
}