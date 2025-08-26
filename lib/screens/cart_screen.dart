import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.nBlue,
        iconTheme: IconThemeData(color: Constants.nGrey),
        title: Text('Shopping Cart' ,style: TextStyle(color: Constants.nGrey , fontWeight: FontWeight.bold),),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return cartProvider.isEmpty
                  ? Container()
                  : IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Clear Cart'),
                      content: Text('Are you sure you want to clear all items?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel' , style: TextStyle(color: Constants.nCharcoal),),
                        ),
                        TextButton(
                          onPressed: () {
                            cartProvider.clearCart();
                            Navigator.pop(context);
                          },
                          child: Text('Clear', style: TextStyle(color: Constants.nOrange),),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/categories'),
                    child: Text('Start Shopping' , style: TextStyle(color: Constants.nBlue),),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      child: ListTile(
                        leading: Image.network(
                          item.product.thumbnail,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[200],
                              child: Icon(Icons.image),
                            );
                          },
                        ),
                        title: Text(item.product.title),
                        subtitle: Text('\$${item.product.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove , color: Constants.nBlue,),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  cartProvider.updateQuantity(
                                    item.product.id,
                                    item.quantity - 1,
                                  );
                                }
                              },
                            ),
                            Text('${item.quantity}' , style: TextStyle(color: Constants.nBlue, fontSize: 12),),
                            IconButton(
                              icon: Icon(Icons.add , color: Constants.nBlue,),
                              onPressed: () {
                                cartProvider.updateQuantity(
                                  item.product.id,
                                  item.quantity + 1,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Constants.nOrange),
                              onPressed: () {
                                cartProvider.removeFromCart(item.product.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Items: ${cartProvider.itemCount}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Total: ${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Checkout functionality coming soon!')),
                          );
                        },
                        child: Text('Proceed to Checkout' ,style: TextStyle(fontWeight: FontWeight.bold , color: Constants.nBlue),),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Constants.nGrey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}