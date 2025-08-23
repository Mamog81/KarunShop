import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  List<Category> get filteredCategories => _filteredCategories;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.getCategories();
      if (result != null) {
        _categories = result.map((name) => Category.fromString(name)).toList();
        _filteredCategories = _categories;
      }
    } catch (e) {
      print('Load categories error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      _filteredCategories = _categories;
    } else {
      _filteredCategories = _categories
          .where((category) => category.displayName
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}