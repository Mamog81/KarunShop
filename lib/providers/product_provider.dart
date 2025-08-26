import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Product> _amazingDeals = [];

  bool _isLoading = false;
  bool _isSearching = false;
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get amazingDeals => _amazingDeals;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  bool get isSearching => _isSearching;

  // متد لود اولیه محصولات بر اساس دسته‌بندی
  Future<void> loadProductsByCategory(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.getProductsByCategory(category);
      if (result != null && result['products'] != null) {
        _products = (result['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
        _filteredProducts = _products; // در ابتدا، لیست فیلتر شده برابر با لیست اصلی است
      }
    } catch (e) {
      print('Load products error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // متد جستجوی محلی (برای CategoryScreen)
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products; // اگر کوئری خالی شد، لیست فیلتر شده به لیست اصلی برمی‌گردد
    } else {
      _filteredProducts = _products
          .where((product) =>
          product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // متد لود تدریجی محصولات (برای AllProductsScreen)
  Future<void> loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.getAllProducts(limit: _limit, skip: _skip);
      if (result != null && result['products'] != null) {
        final newProducts = (result['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();

        if (newProducts.isEmpty) {
          _hasMore = false;
        } else {
          _products.addAll(newProducts);
          _skip += _limit;
        }
      }
    } catch (e) {
      print('Load products error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // متد جستجوی بر اساس API (برای AllProductsScreen)
  Future<void> searchProductsByApi(String query) async {
    _isLoading = true;
    _isSearching = true; // Set to true when a search starts
    _products.clear(); // Clear existing products
    _hasMore = false; // Disable infinite scroll for search results
    _skip = 0; // Reset skip for any future general browsing
    notifyListeners();

    try {
      final result = await _apiService.searchProducts(query);
      if (result != null && result['products'] != null) {
        _products = (result['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Search products by API error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAmazingDeals() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.getAmazingDeals();
      if (result != null && result['products'] != null) {
        _amazingDeals = (result['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Load amazing deals error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // متد پاکسازی لیست‌ها
  void clearProducts() {
    _products.clear();
    _filteredProducts.clear();
    _amazingDeals.clear();
    _skip = 0;
    _hasMore = true;
    _isSearching = false;
    notifyListeners();
  }
}