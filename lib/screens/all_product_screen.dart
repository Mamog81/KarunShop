// AllProductsScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.clearProducts();
      provider.loadMoreProducts();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !provider.isLoading && provider.hasMore) {
        provider.loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Method to handle the search button press
  void _performSearch() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (searchController.text.isNotEmpty) {
      provider.searchProductsByApi(searchController.text);
    } else {
      provider.clearProducts();
      provider.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Products',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                )

              ),
              Expanded(
                child: productProvider.isLoading && productProvider.products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : productProvider.products.isEmpty
                    ? const Center(
                  child: Text(
                    'No products found.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
                    : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.9,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: productProvider.products.length + (productProvider.isLoading ? 1 : 0),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    if (index < productProvider.products.length) {
                      final product = productProvider.products[index];
                      return Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return ProductCard(
                            product: product.toJson(),
                            onAddToCart: () {
                              cartProvider.addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.title} added to cart'),
                                  duration: const Duration(seconds: 1),
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
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
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