import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../utils/constants.dart';

class AmazingDealsScreen extends StatefulWidget {
  @override
  _AmazingDealsScreenState createState() => _AmazingDealsScreenState();
}

class _AmazingDealsScreenState extends State<AmazingDealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadAmazingDeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.nGrey),
        title: Text('Amazing Deals' , style: TextStyle(color: Constants.nGrey , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.nBlue,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (productProvider.amazingDeals.isEmpty) {
            return Center(
              child: Text(
                'No amazing deals found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.52,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: productProvider.amazingDeals.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final product = productProvider.amazingDeals[index];
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
          );
        },
      ),
    );
  }
}
