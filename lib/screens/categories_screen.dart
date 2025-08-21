import 'package:flutter/material.dart';
import 'package:onlineshop/services/api_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoriesScreen> {
  List<String> categories = [];
  List<String> filteredCategories = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var result = await ApiService().getCategories();
    setState(() {
      if (result != null) {
        categories = result;
        filteredCategories = result;
      }
      isLoading = false;
    });
  }

  _searchCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCategories = categories;
      } else {
        filteredCategories = categories
            .where((category) => category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search Box
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchCategories,
            ),
          ),
          // Categories List
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(_formatCategoryName(filteredCategories[index])),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // اینجا onPressed رو خودت بنویس
                      print('Selected: ${filteredCategories[index]}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // تبدیل نام کتگوری به فرمت زیبا
  String _formatCategoryName(String category) {
    return category
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

}