import 'package:flutter/material.dart';
import 'package:onlineshop/services/api_service.dart';
import 'package:onlineshop/widgets/product_card.dart'; // اضافه کردن import

class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    searchController.addListener(() {
      _searchProducts(searchController.text);  // اضافه کردن لیسنر برای جستجو
    });
  }

  // بارگذاری محصولات از API بر اساس دسته‌بندی
  _loadProducts() async {
    var result = await ApiService().getProductsByCategory(widget.category);
    setState(() {
      if (result != null) {
        products = List<Map<String, dynamic>>.from(result['products']);
        filteredProducts = products;  // در ابتدا همه محصولات را نمایش می‌دهیم
      }
      isLoading = false;
    });
  }

  // جستجو در محصولات
  _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;  // اگر چیزی جستجو نشد، همه محصولات نمایش داده می‌شود
      } else {
        filteredProducts = products
            .where((product) =>
            product['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();  // فیلتر کردن محصولات بر اساس عنوان
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_formatCategoryName(widget.category)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(
        child: Text(
          'No products found in this category',
          style: TextStyle(fontSize: 16),
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredProducts.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: filteredProducts[index],
                  onAddToCart: () {
                    print('Added to cart: ${filteredProducts[index]['title']}');
                    // اینجا add to cart logic اضافه کن
                  },
                  onTap: () {
                    print('Product tapped: ${filteredProducts[index]['title']}');
                    // اینجا navigate to product detail
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // فرمت کردن نام دسته‌بندی برای نمایش
  String _formatCategoryName(String category) {
    return category
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
