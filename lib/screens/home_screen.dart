import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> categories = [];
  List<dynamic> recommendedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchRecommendedProducts();
  }

  // دریافت دسته‌بندی‌ها از API
  _fetchCategories() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/categories'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // دریافت محصولات پیشنهادی از API
  _fetchRecommendedProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      setState(() {
        recommendedProducts = json.decode(response.body)['products'];
      });
    } else {
      throw Exception('Failed to load recommended products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // نمایش دسته‌بندی‌ها
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            categories.isNotEmpty
                ? GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Text(categories[index]),
                  ),
                );
              },
            )
                : Center(child: CircularProgressIndicator()),

            // نمایش محصولات پیشنهادی
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recommended Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            recommendedProducts.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: recommendedProducts.length,
              itemBuilder: (context, index) {
                var product = recommendedProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('\$${product['price']}'),
                  leading: Image.network(product['image']),
                  onTap: () {
                    // برای نمایش جزئیات محصول به صفحه دیگر منتقل بشید
                    Navigator.pushNamed(context, '/product_detail');
                  },
                );
              },
            )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
