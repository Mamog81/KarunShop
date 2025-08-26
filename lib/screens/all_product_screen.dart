import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../utils/constants.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  String? initialQuery; // برای ذخیره query اولیه

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !provider.isLoading && provider.hasMore) {
        provider.loadMoreProducts();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // دریافت arguments از route
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final queryFromHome = arguments?['query'] as String?;

    // اگر query جدیدی از home آمده و با query قبلی متفاوت است
    if (queryFromHome != null && queryFromHome != initialQuery) {
      initialQuery = queryFromHome;
      searchController.text = queryFromHome;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<ProductProvider>(context, listen: false);
        provider.clearProducts();
        provider.searchProductsByApi(queryFromHome);
      });
    } else if (queryFromHome == null && initialQuery == null) {
      // اگر هیچ query ای نیست، محصولات عادی رو لود کن
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<ProductProvider>(context, listen: false);
        provider.clearProducts();
        provider.loadMoreProducts();
      });
    }
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

  // Method to clear search and load all products
  void _clearSearch() {
    searchController.clear();
    initialQuery = null;
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.clearProducts();
    provider.loadMoreProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.nGrey),
        backgroundColor: Constants.nBlue,
        title: const Text('Products' , style: TextStyle(color: Constants.nGrey , fontWeight: FontWeight.bold),),
        elevation: 2,
        actions: [

          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              if (provider.isSearching || searchController.text.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                  tooltip: 'Clear Search',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
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
                    ),
                    onSubmitted: (_) => _performSearch(),
                    onChanged: (value) {
                      setState(() {}); // برای update کردن clear button
                    },
                  ),
                ),
              )
              ,



              // Search Results Info
              if (productProvider.isSearching && !productProvider.isLoading)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Found ${productProvider.products.length} products',
                    style: TextStyle(
                      color: Constants.nCharcoal.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              // Products Grid
              Expanded(
                child: _buildProductsContent(productProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductsContent(ProductProvider productProvider) {
    // Loading state - first load
    if (productProvider.isLoading && productProvider.products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading products...'),
          ],
        ),
      );
    }

    // Empty state
    if (productProvider.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                productProvider.isSearching ? Icons.search_off : Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                productProvider.isSearching
                    ? 'No products found'
                    : 'No products available',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                productProvider.isSearching
                    ? 'Try searching with different keywords'
                    : 'Please check back later',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              if (productProvider.isSearching) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.refresh),
                  label: const Text('View All Products'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Products Grid
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: 0.52,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: productProvider.products.length + (productProvider.isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        // Loading indicators at the bottom
        if (index >= productProvider.products.length) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        // Product card
        final product = productProvider.products[index];
        return Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return ProductCard(
              product: product.toJson(),
              onAddToCart: () {
                cartProvider.addToCart(product);
                _showAddToCartSnackBar(product.title);
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
    );
  }

  // Fixed cross axis count - always 2 columns
  int _getCrossAxisCount(BuildContext context) {
    return 2;
  }

  void _showAddToCartSnackBar(String productTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$productTitle added to cart',
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}