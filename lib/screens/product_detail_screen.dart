import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String category;

  ProductDetailScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Detail')),
      body: Center(child: Text('Details of products in $category category')),
    );
  }
}
