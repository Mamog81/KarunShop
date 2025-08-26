import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../utils/constants.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadProductsByCategory(widget.category);
    });

    searchController.addListener(() {
      Provider.of<ProductProvider>(context, listen: false)
          .searchProducts(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _formatCategoryName(String category) {
    return category
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.nBlue,
        iconTheme: IconThemeData(color: Constants.nGrey),
        title: Text(_formatCategoryName(widget.category) ,style: TextStyle(color: Constants.nGrey , fontWeight: FontWeight.bold),),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (productProvider.products.isEmpty) {
            return Center(
              child: Text(
                'No products found in this category',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            children: [


              Container(
                padding: EdgeInsets.symmetric(vertical: 30 , horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Constants.nBlue,
                      Constants.nBlue.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.nGrey,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.nCharcoal.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Constants.nBlue,
                          size: 24,
                        ),
                        // onPressed: _onSearchPressed,
                        onPressed: ()=>{},
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),                  ),
                ),
              )
              ,

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.52,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: productProvider.filteredProducts.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final product = productProvider.filteredProducts[index];
                    return Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return ProductCard(
                          product: product.toJson(),
                          onAddToCart: () {
                            cartProvider.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: product,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}