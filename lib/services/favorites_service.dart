import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._internal();
  static final FavoritesService instance = FavoritesService._internal();

  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool isFavorite(String productId) {
    return _items.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}